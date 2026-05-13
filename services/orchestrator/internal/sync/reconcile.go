package sync

import (
	"log"
	"time"
)

// P5-T03: Hybrid State Sync Engine (Go Orchestrator side)
//
// Builds the reconciliation engine that merges local Edge state with Cloud state
// the moment the WebSocket connection is re-established.

type Reconciler struct {
	// dependencies like db connections or redis could be injected here
}

func NewReconciler() *Reconciler {
	return &Reconciler{}
}

// Intent represents a normalized command from either edge or cloud.
type Intent struct {
	ID        string
	Text      string
	Timestamp time.Time
	Source    string // "edge" or "cloud"
	Status    string
}

// ReconcileIntents merges edge state with cloud state.
// If a conflict occurs (same ID), it resolves based on timestamp.
func (r *Reconciler) ReconcileIntents(edgeState map[string]interface{}, cloudState map[string]interface{}) map[string]interface{} {
	log.Println("Reconciler: Starting reconciliation process between Edge and Cloud states")

	mergedState := make(map[string]interface{})

	// 1. Load Cloud state as base
	for k, v := range cloudState {
		mergedState[k] = v
	}

	// 2. Overlay Edge state
	for k, v := range edgeState {
		edgeIntent, isEdgeMap := v.(map[string]interface{})
		cloudIntent, hasCloud := mergedState[k].(map[string]interface{})

		if !hasCloud {
			// Intent only exists on Edge, accept it
			mergedState[k] = v
			log.Printf("Reconciler: Accepted new Edge intent: %s", k)
			continue
		}

		if isEdgeMap && hasCloud {
			// Conflict: intent exists in both. Resolve by Timestamp.
			edgeTsStr, _ := edgeIntent["created_at"].(string)
			cloudTsStr, _ := cloudIntent["created_at"].(string)

			edgeTime, errEdge := time.Parse(time.RFC3339, edgeTsStr)
			cloudTime, errCloud := time.Parse(time.RFC3339, cloudTsStr)

			if errEdge == nil && errCloud == nil {
				if edgeTime.After(cloudTime) {
					// Edge state is newer, overwrite
					mergedState[k] = v
					log.Printf("Reconciler: Overwriting Cloud intent %s with newer Edge intent", k)
				} else {
					log.Printf("Reconciler: Cloud intent %s is newer, ignoring Edge intent", k)
				}
			} else {
				// Fallback if parsing fails: trust edge since it's the sync source
				mergedState[k] = v
				log.Printf("Reconciler: Timestamp parse error, defaulting to Edge intent %s", k)
			}
		} else {
			// Non-map types, just overwrite
			mergedState[k] = v
		}
	}

	log.Println("Reconciler: Reconciliation complete")
	return mergedState
}
