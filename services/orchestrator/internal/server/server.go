package server

import (
	"log"
	"net/http"
	"os"
	"strings"
	"time"

	"github.com/ericfranzee/Verve/services/orchestrator/internal/circuit"
	"github.com/ericfranzee/Verve/services/orchestrator/internal/session"
	"github.com/ericfranzee/Verve/services/orchestrator/internal/sync"

	"bytes"

	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool {
		origin := r.Header.Get("Origin")
		if origin == "" {
			return true // Non-browser requests allowed
		}

		allowedOriginsEnv := os.Getenv("ALLOWED_ORIGINS")
		if allowedOriginsEnv == "" {
			return true // Default open for development if not set, though ideally it should be restrictive
		}

		allowedOrigins := strings.Split(allowedOriginsEnv, ",")
		for _, allowed := range allowedOrigins {
			if strings.TrimSpace(allowed) == origin {
				return true
			}
		}
		return false
	},
}

type WSServer struct {
	clients map[*websocket.Conn]bool
	sessionMgr *session.SessionManager
	intentBreaker *circuit.CircuitBreaker
	reconciler *sync.Reconciler
}

func NewWSServer() *WSServer {
	redisAddr := os.Getenv("REDIS_ADDR")
	if redisAddr == "" {
		redisAddr = "localhost:6379"
	}
	return &WSServer{
		clients: make(map[*websocket.Conn]bool),
		sessionMgr: session.NewSessionManager(redisAddr),
		intentBreaker: circuit.NewCircuitBreaker("IntentEngine", 5, time.Minute, 30*time.Second),
		reconciler: sync.NewReconciler(),
	}
}

func (s *WSServer) HandleConnections(w http.ResponseWriter, r *http.Request) {
	ws, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Printf("Upgrade error: %v", err)
		return
	}
	defer ws.Close()

	sessionID := r.URL.Query().Get("session_id")
	if sessionID != "" {
		_, err := s.sessionMgr.RecoverSession(sessionID)
		if err != nil {
			log.Printf("Error recovering session: %v", err)
		}
	}

	s.clients[ws] = true
	log.Printf("Client connected. Total clients: %d", len(s.clients))

	for {
		var msg map[string]interface{}
		err := ws.ReadJSON(&msg)
		if err != nil {
			log.Printf("Read error: %v", err)
			delete(s.clients, ws)
			break
		}

		log.Printf("Received message: %v", msg)

		// Check if it's a sync message
		if action, ok := msg["action"].(string); ok && action == "sync" {
			edgeState, _ := msg["edge_state"].(map[string]interface{})
			// Stub cloud state retrieval (would normally fetch from DB/Redis)
			cloudState := make(map[string]interface{})

			mergedState := s.reconciler.ReconcileIntents(edgeState, cloudState)

			response := map[string]interface{}{
				"action": "sync_complete",
				"merged_state": mergedState,
			}
			err = ws.WriteJSON(response)
			if err != nil {
				log.Printf("Write error: %v", err)
				ws.Close()
				delete(s.clients, ws)
				break
			}
			continue
		}

		// Stub intent engine call through circuit breaker
		_, _ = s.intentBreaker.Execute(func() (interface{}, error) {
			// Simulate Intent Engine API call
			return nil, nil
		})

		// Echo message back for now
		err = ws.WriteJSON(msg)
		if err != nil {
			log.Printf("Write error: %v", err)
			ws.Close()
			delete(s.clients, ws)
			break
		}
	}
}

func (s *WSServer) HandlePurge(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	authHeader := r.Header.Get("Authorization")
	if authHeader == "" {
		http.Error(w, "Unauthorized", http.StatusUnauthorized)
		return
	}

	// 1. Forward to Python Intent Engine
	reqBody := []byte(`{"user_id": "current_user_123"}`) // In reality, parse from request/token
	req, err := http.NewRequest("POST", "http://localhost:8000/internal/purge", bytes.NewBuffer(reqBody))
	if err != nil {
		log.Printf("Failed to create request for purge cascade: %v", err)
		http.Error(w, "Internal server error during purge cascade", http.StatusInternalServerError)
		return
	}
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Authorization", authHeader)

	client := &http.Client{Timeout: 2 * time.Second}
	resp, err := client.Do(req)

	if err != nil || resp.StatusCode != http.StatusOK {
		log.Printf("Failed to cascade purge to Intent Engine: %v", err)
		http.Error(w, "Internal server error during purge cascade", http.StatusInternalServerError)
		return
	}

	// 2. Clear Session in Redis (stubbed out here since we don't have the user's specific session ID without parsing the token)
	// s.sessionMgr.ClearUserSessions(userID)

	log.Println("Purge cascade successful.")
	w.WriteHeader(http.StatusOK)
	w.Write([]byte(`{"status":"success"}`))
}
