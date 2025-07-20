package usecase

import (
	"go-api/internal/modules/hello/domain/entity"
	"go-api/internal/modules/hello/domain/service"
)

// HelloUseCase はHelloのユースケースを定義します
type HelloUseCase interface {
	GetHelloMessage() *entity.Hello
}

// helloUseCase はHelloUseCaseの実装です
type helloUseCase struct {
	helloService *service.HelloService
}

// NewHelloUseCase は新しいHelloUseCaseを作成します
func NewHelloUseCase(helloService *service.HelloService) HelloUseCase {
	return &helloUseCase{
		helloService: helloService,
	}
}

// GetHelloMessage はHelloメッセージを取得します
func (u *helloUseCase) GetHelloMessage() *entity.Hello {
	return u.helloService.CreateHelloMessage()
}
