package dto

import (
	"time"
)

// HelloResponse はHello APIのレスポンスDTOです
type HelloResponse struct {
	Message   string    `json:"message"`
	Timestamp time.Time `json:"timestamp"`
}

// NewHelloResponse は新しいHelloResponseを作成します
func NewHelloResponse(message string, timestamp time.Time) *HelloResponse {
	return &HelloResponse{
		Message:   message,
		Timestamp: timestamp,
	}
}
