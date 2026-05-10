package circuit

import (
	"errors"
	"log"
	"sync"
	"time"
)

type State int

const (
	StateClosed State = iota
	StateOpen
	StateHalfOpen
)

type CircuitBreaker struct {
	mu           sync.RWMutex
	name         string
	state        State
	failures     int
	threshold    int
	window       time.Duration
	cooldown     time.Duration
	lastFailure  time.Time
}

func NewCircuitBreaker(name string, threshold int, window time.Duration, cooldown time.Duration) *CircuitBreaker {
	return &CircuitBreaker{
		name:      name,
		state:     StateClosed,
		threshold: threshold,
		window:    window,
		cooldown:  cooldown,
	}
}

func (cb *CircuitBreaker) Execute(fn func() (interface{}, error)) (interface{}, error) {
	cb.mu.Lock()

	if cb.state == StateOpen {
		if time.Since(cb.lastFailure) > cb.cooldown {
			cb.state = StateHalfOpen
		} else {
			cb.mu.Unlock()
			return nil, errors.New("circuit breaker is open")
		}
	}
	cb.mu.Unlock()

	result, err := fn()

	cb.mu.Lock()
	defer cb.mu.Unlock()

	if err != nil {
		cb.failures++
		cb.lastFailure = time.Now()
		if cb.failures >= cb.threshold {
			cb.state = StateOpen
			log.Printf("Circuit breaker %s is OPEN", cb.name)
		}
		return nil, err
	}

	// Success
	if cb.state == StateHalfOpen {
		cb.state = StateClosed
		cb.failures = 0
		log.Printf("Circuit breaker %s is CLOSED", cb.name)
	} else if cb.state == StateClosed {
		cb.failures = 0 // reset failures within window logic could be improved
	}

	return result, nil
}
