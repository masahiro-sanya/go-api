//go:build wireinject
// +build wireinject

package di

import (
	"go-api/internal/modules/hello/domain/service"
	"go-api/internal/modules/hello/handler"
	"go-api/internal/modules/hello/usecase"
	"go-api/internal/shared/interface/router"

	"github.com/google/wire"
	"github.com/labstack/echo/v4"
)

// Server はアプリケーションサーバーを表します
type Server struct {
	echo         *echo.Echo
	router       *router.Router
	helloHandler *handler.HelloHandler
}

// NewServer は新しいServerを作成します
func NewServer(e *echo.Echo, r *router.Router, h *handler.HelloHandler) *Server {
	return &Server{
		echo:         e,
		router:       r,
		helloHandler: h,
	}
}

// Start はサーバーを起動します
func (s *Server) Start(addr string) error {
	// ミドルウェアを設定
	// middleware.SetupMiddleware(s.echo)

	// ルートを設定
	s.router.SetupRoutes(s.helloHandler)

	return s.echo.Start(addr)
}

func InitializeServer() (*Server, error) {
	wire.Build(
		echo.New,
		service.NewHelloService,
		usecase.NewHelloUseCase,
		handler.NewHelloHandler,
		router.NewRouter,
		NewServer,
	)
	return &Server{}, nil
}
