package handler

import (
	"net/http"

	"go-api/internal/modules/hello/dto"
	"go-api/internal/modules/hello/usecase"

	"github.com/labstack/echo/v4"
)

// HelloHandler はHelloのHTTPハンドラーです
type HelloHandler struct {
	helloUseCase usecase.HelloUseCase
}

// NewHelloHandler は新しいHelloHandlerを作成します
func NewHelloHandler(helloUseCase usecase.HelloUseCase) *HelloHandler {
	return &HelloHandler{
		helloUseCase: helloUseCase,
	}
}

// Hello はHello Worldエンドポイントを処理します
func (h *HelloHandler) Hello(c echo.Context) error {
	hello := h.helloUseCase.GetHelloMessage()

	response := dto.NewHelloResponse(
		hello.GetMessage(),
		hello.GetTimestamp(),
	)

	return c.JSON(http.StatusOK, response)
}
