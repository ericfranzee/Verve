package security

import (
	"crypto/hmac"
	"crypto/sha256"
	"encoding/hex"
	"errors"
	"os"
)

// P5-T16: Phase 5 Penetration Testing
// Defending against Edge model extraction and spoofing by enforcing Device Attestation.

type AttestationService struct {
	secretKey []byte
}

func NewAttestationService() *AttestationService {
	// In production, this comes from a secure vault
	key := os.Getenv("ATTESTATION_SECRET_KEY")
	if key == "" {
		key = "default-development-attestation-key-1234"
	}
	return &AttestationService{secretKey: []byte(key)}
}

// VerifyDevicePayload ensures that the payload coming from the offline queue
// or the local Edge SLM hasn't been spoofed or tampered with.
func (s *AttestationService) VerifyDevicePayload(payload string, providedSignature string) error {
	h := hmac.New(sha256.New, s.secretKey)
	h.Write([]byte(payload))
	expectedSignature := hex.EncodeToString(h.Sum(nil))

	if !hmac.Equal([]byte(expectedSignature), []byte(providedSignature)) {
		return errors.New("device attestation failed: signature mismatch. possible spoofing attempt")
	}

	return nil
}
