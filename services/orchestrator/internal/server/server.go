package server

import (
	"log"
	"net/http"
	"time"

	"github.com/ericfranzee/Verve/services/orchestrator/internal/circuit"
	"github.com/ericfranzee/Verve/services/orchestrator/internal/session"
	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool {
		return true // Allow all for development
	},
}

type WSServer struct {
	clients map[*websocket.Conn]bool
	sessionMgr *session.SessionManager
	intentBreaker *circuit.CircuitBreaker
}

func NewWSServer() *WSServer {
	return &WSServer{
		clients: make(map[*websocket.Conn]bool),
		sessionMgr: session.NewSessionManager(),
		intentBreaker: circuit.NewCircuitBreaker("IntentEngine", 5, time.Minute, 30*time.Second),
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
