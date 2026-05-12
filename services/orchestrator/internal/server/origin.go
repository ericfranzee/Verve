package server

import (
	"log"
	"net/http"
)

func (s *WSServer) checkOrigin(r *http.Request) bool {
	origin := r.Header.Get("Origin")
	allowed := IsOriginAllowed(origin, s.allowedOrigins)
	if !allowed {
		log.Printf("Blocked connection from unauthorized origin: %s", origin)
	}
	return allowed
}

// IsOriginAllowed checks if the given origin is in the allowed list.
// Non-browser requests (empty origin) are always allowed.
func IsOriginAllowed(origin string, allowedOrigins []string) bool {
	if origin == "" {
		return true // Allow non-browser requests
	}

	for _, allowed := range allowedOrigins {
		if origin == allowed {
			return true
		}
	}

	return false
}
