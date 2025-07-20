package main

import (
	"log"

	"go-api/internal/di"
)

func main() {
	// Wireで依存関係を解決
	server, err := di.InitializeServer()
	if err != nil {
		log.Fatal("Failed to initialize server:", err)
	}

	// サーバーを起動
	log.Printf("Server starting on :8081")
	if err := server.Start(":8081"); err != nil {
		log.Fatal("Failed to start server:", err)
	}
}
