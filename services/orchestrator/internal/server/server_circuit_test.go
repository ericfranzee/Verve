package server

import (
	"errors"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gorilla/websocket"
)

// P4-T11: Circuit Breaker Verification Tests
func TestCircuitBreakerTripsAndFallsback(t *testing.T) {
	wsServer := NewWSServer()

	// Create a new test server to test the websocket route
	s := httptest.NewServer(http.HandlerFunc(wsServer.HandleConnections))
	defer s.Close()

	// Connect to WS
	wsURL := "ws" + s.URL[4:]
	ws, _, err := websocket.DefaultDialer.Dial(wsURL, nil)
	if err != nil {
		t.Fatalf("Could not connect to WS: %v", err)
	}
	defer ws.Close()

	// Manually trip the breaker
	for i := 0; i < 5; i++ {
		_, err := wsServer.intentBreaker.Execute(func() (interface{}, error) {
			return nil, errors.New("simulated intentional failure")
		})
		if err == nil {
			t.Errorf("Expected simulated failure, got nil")
		}
	}

	// Now the breaker should be OPEN.
	_, err = wsServer.intentBreaker.Execute(func() (interface{}, error) {
		return "should not run", nil
	})

	if err == nil {
		t.Fatalf("Expected circuit breaker to be open, but call succeeded")
	}

	if err.Error() != "circuit breaker is open" {
		t.Fatalf("Expected error 'circuit breaker is open', got '%v'", err)
	}
}
