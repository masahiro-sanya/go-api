package router

import (
	"go-api/internal/modules/hello/handler"

	"github.com/labstack/echo/v4"
)

// Router はルーティング設定を管理します
type Router struct {
	echo *echo.Echo
}

// NewRouter は新しいRouterを作成します
func NewRouter(e *echo.Echo) *Router {
	return &Router{
		echo: e,
	}
}

// SetupRoutes はルートを設定します
func (r *Router) SetupRoutes(helloHandler *handler.HelloHandler) {
	// Hello routes
	r.echo.GET("/hello", helloHandler.Hello)
}
