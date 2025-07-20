package entity

import (
	"time"
)

// Hello はHello Worldのドメインエンティティです
type Hello struct {
	Message   string
	Timestamp time.Time
}

// NewHello は新しいHelloエンティティを作成します
func NewHello(message string) *Hello {
	return &Hello{
		Message:   message,
		Timestamp: time.Now(),
	}
}

// GetMessage はメッセージを取得します
func (h *Hello) GetMessage() string {
	return h.Message
}

// GetTimestamp はタイムスタンプを取得します
func (h *Hello) GetTimestamp() time.Time {
	return h.Timestamp
}
