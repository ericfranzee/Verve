package server

import (
	"bytes"
	"net/http"
	"net/http/httptest"
	"os"
	"testing"
)

func TestCheckOrigin(t *testing.T) {
	// Set up environment for allowed origins
	os.Setenv("ALLOWED_ORIGINS", "http://localhost:3000,https://verve.app")
	defer os.Unsetenv("ALLOWED_ORIGINS")

	tests := []struct {
		name       string
		origin     string
		shouldPass bool
	}{
		{"Allowed Localhost", "http://localhost:3000", true},
		{"Allowed Prod", "https://verve.app", true},
		{"No Origin (Non-browser)", "", true},
		{"Disallowed Origin", "http://attacker.com", false},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			req := httptest.NewRequest("GET", "http://localhost:8080/ws", nil)
			if tt.origin != "" {
				req.Header.Set("Origin", tt.origin)
			}

			// Directly call the CheckOrigin function
			result := upgrader.CheckOrigin(req)

			if result != tt.shouldPass {
				t.Errorf("expected CheckOrigin to return %v, got %v for origin %q", tt.shouldPass, result, tt.origin)
			}
		})
	}
}

func TestHandlePurge_Unauthorized(t *testing.T) {
	wsServer := NewWSServer()

	req := httptest.NewRequest("POST", "/api/v1/purge", nil)
	// Do not set Authorization header

	rr := httptest.NewRecorder()

	wsServer.HandlePurge(rr, req)

	if status := rr.Code; status != http.StatusUnauthorized {
		t.Errorf("HandlePurge returned wrong status code: got %v want %v", status, http.StatusUnauthorized)
	}
}

func TestHandlePurge_PayloadInjection(t *testing.T) {
	wsServer := NewWSServer()

	// Malformed JSON payload
	reqBody := []byte(`{"user_id": "current_user_123" MALFORMED `)
	req := httptest.NewRequest("POST", "/api/v1/purge", bytes.NewBuffer(reqBody))
	req.Header.Set("Authorization", "Bearer mock_token") // To bypass unauthorized check

	rr := httptest.NewRecorder()

	// This shouldn't panic, it should just fail cleanly (in current implementation it just forwards the body, but it shouldn't panic)
	// We'll just ensure it completes without panicking
	defer func() {
		if r := recover(); r != nil {
			t.Errorf("HandlePurge panicked on malformed input: %v", r)
		}
	}()

	wsServer.HandlePurge(rr, req)

	// In the real system, it would return 500 because the downstream Intent Engine isn't running in this test,
	// but the primary concern of this test is ensuring no panics occur on bad payload.
	if rr.Code != http.StatusInternalServerError {
		t.Logf("Expected 500 due to Intent Engine being down, got %v", rr.Code)
	}
}
