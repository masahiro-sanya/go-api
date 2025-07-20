.PHONY: help build run dev test clean wire deps install-tools setup

help: ## ヘルプを表示
	@echo "使用可能なコマンド:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

build: ## アプリケーションをビルド
	go build -o bin/main cmd/main.go

run: ## アプリケーションを実行
	go run cmd/main.go

dev: ## ホットリロードで開発サーバーを起動
	air

test: ## テストを実行
	go test ./...

clean: ## ビルドファイルを削除
	rm -rf bin/
	rm -rf tmp/

wire: ## Wireコードを生成
	wire ./internal/di

deps: ## 依存関係をインストール
	go mod tidy

install-tools: ## 必要なツールをインストール
	go install github.com/google/wire/cmd/wire@latest
	go install github.com/air-verse/air@latest

setup: deps install-tools wire ## プロジェクトの初期セットアップ

api-test: ## APIテストを実行
	@echo "Testing Hello endpoint..."
	curl -s http://localhost:8081/hello | jq .

new-module: ## 新しいモジュールを作成（引数: MODULE_NAME=module_name）
	@if [ -z "$(MODULE_NAME)" ]; then \
		echo "Usage: make new-module MODULE_NAME=module_name"; \
		exit 1; \
	fi
	@echo "Creating new module: $(MODULE_NAME)"
	@mkdir -p internal/modules/$(MODULE_NAME)/domain/entity
	@mkdir -p internal/modules/$(MODULE_NAME)/domain/repository
	@mkdir -p internal/modules/$(MODULE_NAME)/domain/service
	@mkdir -p internal/modules/$(MODULE_NAME)/domain/value
	@mkdir -p internal/modules/$(MODULE_NAME)/usecase
	@mkdir -p internal/modules/$(MODULE_NAME)/handler
	@mkdir -p internal/modules/$(MODULE_NAME)/dto
	@echo "Module $(MODULE_NAME) created successfully!"
	@echo "Don't forget to update wire.go and regenerate wire code"

lint: ## コードの静的解析を実行
	golangci-lint run

format: ## コードをフォーマット
	go fmt ./...
	go vet ./... 