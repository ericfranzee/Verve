package main

import (
	"log"
	"net/http"
	"os"
	"strings"

	"github.com/ericfranzee/Verve/services/orchestrator/internal/server"
)

func main() {
	allowedOriginsEnv := os.Getenv("ALLOWED_ORIGINS")
	var allowedOrigins []string
	if allowedOriginsEnv != "" {
		allowedOrigins = strings.Split(allowedOriginsEnv, ",")
		for i := range allowedOrigins {
			allowedOrigins[i] = strings.TrimSpace(allowedOrigins[i])
		}
	} else {
		log.Println("WARNING: ALLOWED_ORIGINS not set. WebSocket will only accept non-browser requests.")
	}

	wsServer := server.NewWSServer(allowedOrigins)

	http.HandleFunc("/ws", wsServer.HandleConnections)
	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		w.Write([]byte("OK"))
	})

	log.Println("Go Orchestrator started on :8080")
	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}
