package circuit

import (
	"errors"
	"testing"
	"time"
)

func TestCircuitBreaker(t *testing.T) {
	cb := NewCircuitBreaker("TestBreaker", 3, time.Minute, 100*time.Millisecond)

	// Test successful call
	_, err := cb.Execute(func() (interface{}, error) { return "ok", nil })
	if err != nil {
		t.Fatalf("Expected nil err on success, got %v", err)
	}
	if cb.state != StateClosed {
		t.Errorf("Expected state to be CLOSED, got %v", cb.state)
	}

	// Test failures to trip breaker
	for i := 0; i < 3; i++ {
		_, _ = cb.Execute(func() (interface{}, error) { return nil, errors.New("fail") })
	}

	if cb.state != StateOpen {
		t.Errorf("Expected state to be OPEN after 3 failures, got %v", cb.state)
	}

	// Test call while open fails immediately
	_, err = cb.Execute(func() (interface{}, error) { return "ok", nil })
	if err == nil || err.Error() != "circuit breaker is open" {
		t.Errorf("Expected 'circuit breaker is open' err, got %v", err)
	}

	// Test cooldown to half-open
	time.Sleep(150 * time.Millisecond)
	_, err = cb.Execute(func() (interface{}, error) { return "ok", nil })
	if err != nil {
		t.Errorf("Expected successful half-open recovery, got %v", err)
	}

	if cb.state != StateClosed {
		t.Errorf("Expected state to be CLOSED after successful half-open recovery, got %v", cb.state)
	}
}
