package session

import (
	"context"
	"encoding/json"
	"log"
	"sync"
	"time"

	"github.com/redis/go-redis/v9"
)

type Session struct {
	ID         string                 `json:"id"`
	StateData  map[string]interface{} `json:"state_data"`
	LastActive time.Time              `json:"last_active"`
}

type SessionManager struct {
	mu          sync.RWMutex
	sessions    map[string]*Session
	redisClient *redis.Client
}

func NewSessionManager(redisAddr string) *SessionManager {
	client := redis.NewClient(&redis.Options{
		Addr: redisAddr,
	})

	sm := &SessionManager{
		sessions:    make(map[string]*Session),
		redisClient: client,
	}

	// Verify Redis connection on startup
	if _, err := sm.redisClient.Ping(context.Background()).Result(); err != nil {
		log.Printf("Warning: Failed to connect to Redis at %s: %v", redisAddr, err)
	} else {
		log.Printf("Successfully connected to Redis at %s", redisAddr)
	}

	go sm.snapshotRoutine()
	return sm
}

func (sm *SessionManager) snapshotRoutine() {
	ticker := time.NewTicker(5 * time.Second)
	ctx := context.Background()

	for {
		<-ticker.C
		sm.mu.RLock()

		if len(sm.sessions) > 0 {
			for _, sess := range sm.sessions {
				data, err := json.Marshal(sess)
				if err != nil {
					log.Printf("Error marshaling session %s: %v", sess.ID, err)
					continue
				}

				err = sm.redisClient.Set(ctx, "session:"+sess.ID, data, 24*time.Hour).Err()
				if err != nil {
					log.Printf("Error saving session %s to Redis: %v", sess.ID, err)
				}
			}
			log.Printf("Snapshotting %d sessions to Redis", len(sm.sessions))
		}
		sm.mu.RUnlock()
	}
}

func (sm *SessionManager) RecoverSession(sessionID string) (*Session, error) {
	sm.mu.Lock()
	defer sm.mu.Unlock()

	if sess, exists := sm.sessions[sessionID]; exists {
		return sess, nil
	}

	ctx := context.Background()
	val, err := sm.redisClient.Get(ctx, "session:"+sessionID).Result()

	if err == redis.Nil {
		log.Printf("Session %s not found in Redis, creating new", sessionID)
		newSess := &Session{
			ID:         sessionID,
			StateData:  make(map[string]interface{}),
			LastActive: time.Now(),
		}
		sm.sessions[sessionID] = newSess
		return newSess, nil
	} else if err != nil {
		return nil, err
	}

	var recoveredSession Session
	if err := json.Unmarshal([]byte(val), &recoveredSession); err != nil {
		return nil, err
	}

	log.Printf("Recovered session %s from Redis", sessionID)
	sm.sessions[sessionID] = &recoveredSession
	return &recoveredSession, nil
}
