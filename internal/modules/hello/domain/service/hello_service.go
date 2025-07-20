package service

import (
	"go-api/internal/modules/hello/domain/entity"
)

// HelloService はHelloドメインのビジネスロジックを提供します
type HelloService struct{}

// NewHelloService は新しいHelloServiceを作成します
func NewHelloService() *HelloService {
	return &HelloService{}
}

// CreateHelloMessage はHelloメッセージを作成します
func (s *HelloService) CreateHelloMessage() *entity.Hello {
	return entity.NewHello("Hello, World!")
}
