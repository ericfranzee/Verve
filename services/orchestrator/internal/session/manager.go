package session

import (
	"log"
	"sync"
	"time"
)

type Session struct {
	ID        string
	StateData map[string]interface{}
	LastActive time.Time
}

type SessionManager struct {
	mu       sync.RWMutex
	sessions map[string]*Session
}

func NewSessionManager() *SessionManager {
	sm := &SessionManager{
		sessions: make(map[string]*Session),
	}
	go sm.snapshotRoutine()
	return sm
}

func (sm *SessionManager) snapshotRoutine() {
	// P1-T20: Redis session state snapshots (5-second intervals).
	ticker := time.NewTicker(5 * time.Second)
	for {
		<-ticker.C
		sm.mu.RLock()
		// Stub: Serialize and push to Redis
		log.Printf("Snapshotting %d sessions to Redis (stub)", len(sm.sessions))
		sm.mu.RUnlock()
	}
}

func (sm *SessionManager) RecoverSession(sessionID string) (*Session, error) {
	// P1-T21: Session crash recovery (reconnect with session_id -> Redis restore).
	sm.mu.Lock()
	defer sm.mu.Unlock()

	if sess, exists := sm.sessions[sessionID]; exists {
		return sess, nil
	}

	// Stub: Try restoring from Redis
	log.Printf("Recovering session %s from Redis (stub)", sessionID)

	newSess := &Session{
		ID:        sessionID,
		StateData: make(map[string]interface{}),
		LastActive: time.Now(),
	}
	sm.sessions[sessionID] = newSess
	return newSess, nil
}
