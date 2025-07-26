.PHONY: help build run dev test clean wire deps install-tools setup

help: ## ヘルプを表示
	@echo "使用可能なコマンド:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

build: deps wire ## アプリケーションをビルド（依存関係とWireコード生成を含む）
	go build -o bin/main cmd/main.go

run: deps wire ## アプリケーションを実行（依存関係とWireコード生成を含む）
	go run cmd/main.go

dev: deps wire ## ホットリロードで開発サーバーを起動（依存関係とWireコード生成を含む）
	air

test: deps ## テストを実行（依存関係を含む）
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

# 開発用の便利コマンド
dev-setup: deps install-tools wire ## 開発環境のセットアップ（依存関係、ツール、Wireコード生成）
	@echo "Development environment setup completed!"

dev-start: dev-setup dev ## 開発サーバーを起動（セットアップから実行まで一括）

dev-restart: clean dev-setup dev ## 開発サーバーを再起動（クリーンから実行まで一括）

# 本番用コマンド
prod-build: deps wire build ## 本番用ビルド（依存関係、Wireコード生成、ビルド）
	@echo "Production build completed!"

prod-run: deps wire run ## 本番用実行（依存関係、Wireコード生成、実行）

# デバッグ用コマンド
debug: deps wire ## デバッグモードで実行
	go run -race cmd/main.go

# 依存関係の確認
check-deps: ## 依存関係の状態を確認
	@echo "Checking dependencies..."
	go mod verify
	go mod download
	@echo "Dependencies are up to date!"

# プロジェクトの状態確認
status: ## プロジェクトの状態を確認
	@echo "=== Project Status ==="
	@echo "Go version: $(shell go version)"
	@echo "Wire version: $(shell wire version 2>/dev/null || echo 'Not installed')"
	@echo "Air version: $(shell air version 2>/dev/null || echo 'Not installed')"
	@echo "Dependencies: $(shell go list -m all | wc -l) packages"
	@echo "====================="

# CI/CD用コマンド
ci-deps: ## CI用：依存関係をインストール
	go mod download

ci-wire: ## CI用：Wireコードを生成
	go install github.com/google/wire/cmd/wire@latest
	wire ./internal/di

ci-test: ## CI用：テストを実行
	go test -v ./...

ci-build: ci-deps ci-wire ## CI用：ビルド（依存関係とWireコード生成）
	go build -o bin/main cmd/main.go

ci: ci-deps ci-wire ci-test ci-build ## CI用：完全なビルドパイプライン
	@echo "CI build completed successfully!" 