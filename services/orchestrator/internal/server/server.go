package server

import (
	"log"
	"net/http"

	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool {
		return true // Allow all for development
	},
}

type WSServer struct {
	clients map[*websocket.Conn]bool
}

func NewWSServer() *WSServer {
	return &WSServer{
		clients: make(map[*websocket.Conn]bool),
	}
}

func (s *WSServer) HandleConnections(w http.ResponseWriter, r *http.Request) {
	ws, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Printf("Upgrade error: %v", err)
		return
	}
	defer ws.Close()

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
