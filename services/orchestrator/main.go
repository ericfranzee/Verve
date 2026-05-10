package main

import (
	"log"
	"net/http"

	"github.com/ericfranzee/Verve/services/orchestrator/internal/server"
)

func main() {
	wsServer := server.NewWSServer()

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
