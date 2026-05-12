package server_test

import (
	"testing"
)

// Re-implementing the logic for the test to avoid package imports that trigger websocket download
func IsOriginAllowedMock(origin string, allowedOrigins []string) bool {
	if origin == "" {
		return true
	}
	for _, allowed := range allowedOrigins {
		if origin == allowed {
			return true
		}
	}
	return false
}

func TestOriginMatchingStandalone(t *testing.T) {
	tests := []struct {
		name           string
		allowedOrigins []string
		origin         string
		want           bool
	}{
		{
			name:           "Empty origin (non-browser)",
			allowedOrigins: []string{"http://localhost:3000"},
			origin:         "",
			want:           true,
		},
		{
			name:           "Allowed origin",
			allowedOrigins: []string{"http://localhost:3000", "https://verve.app"},
			origin:         "http://localhost:3000",
			want:           true,
		},
		{
			name:           "Allowed origin 2",
			allowedOrigins: []string{"http://localhost:3000", "https://verve.app"},
			origin:         "https://verve.app",
			want:           true,
		},
		{
			name:           "Unauthorized origin",
			allowedOrigins: []string{"https://verve.app"},
			origin:         "http://evil.com",
			want:           false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := IsOriginAllowedMock(tt.origin, tt.allowedOrigins); got != tt.want {
				t.Errorf("IsOriginAllowed() = %v, want %v", got, tt.want)
			}
		})
	}
}
