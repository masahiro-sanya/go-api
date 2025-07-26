# Go API Project

OpenAPI.yamlから取り込んでGoのAPIを作成するプロジェクトです。モジュラーDDD（Domain-Driven Design）アーキテクチャを採用しています。

## 技術スタック

- **フレームワーク**: Echo v4
- **ホットリロード**: Air
- **依存注入**: Wire
- **アーキテクチャ**: モジュラーDDD
- **API仕様**: OpenAPI 3.0

## プロジェクト構造

```
go-api/
├── cmd/                           # アプリケーションエントリーポイント
│   └── main.go                    # メインアプリケーション
├── internal/                      # 内部コード（プライベート）
│   ├── modules/                   # モジュール（ドメイン）
│   │   └── hello/                 # Helloモジュール
│   │       ├── domain/            # ドメイン層
│   │       │   ├── entity/        # エンティティ
│   │       │   ├── repository/    # リポジトリインターフェース
│   │       │   ├── service/       # ドメインサービス
│   │       │   └── value/         # 値オブジェクト
│   │       ├── usecase/           # ユースケース層
│   │       ├── handler/           # ハンドラー層
│   │       └── dto/               # データ転送オブジェクト
│   ├── shared/                    # 共有コンポーネント
│   │   ├── domain/                # 共有ドメイン
│   │   │   ├── entity/            # 共有エンティティ
│   │   │   └── repository/        # 共有リポジトリ
│   │   ├── infrastructure/        # 共有インフラ
│   │   │   ├── database/          # データベース
│   │   │   ├── external/          # 外部サービス
│   │   │   └── config/            # 設定
│   │   ├── interface/             # 共有インターフェース
│   │   │   ├── middleware/        # ミドルウェア
│   │   │   └── router/            # ルーター
│   │   └── utils/                 # ユーティリティ
│   └── di/                        # 依存注入
│       ├── wire.go                # Wire設定
│       └── wire_gen.go            # 生成されたWireコード（Git対象外）
├── openapi/                       # OpenAPI仕様
│   ├── openapi.yaml              # メインOpenAPIファイル
│   ├── schemas/                  # スキーマ定義
│   │   └── hello.yaml            # Helloレスポンススキーマ
│   └── components/               # 共通コンポーネント
│       ├── responses.yaml        # レスポンス定義
│       └── parameters.yaml       # パラメータ定義
├── tmp/                          # 一時ファイル（Air生成、Git対象外）
├── go.mod                        # Goモジュール定義
├── go.sum                        # 依存関係チェックサム
├── .air.toml                     # Air設定（ホットリロード）
├── .gitignore                    # Git除外設定
├── Makefile                      # ビルド・開発コマンド
└── README.md                     # このファイル
```

## アーキテクチャ

このプロジェクトはモジュラーDDDアーキテクチャを採用しています：

### モジュラーDDDの特徴
- **ドメインの独立性**: 各モジュールが独立して管理
- **層の分離**: ドメイン、ユースケース、ハンドラー、DTOの明確な分離
- **依存注入**: Wireを使用したクリーンな依存関係管理
- **スケーラビリティ**: 新しいモジュールの追加が容易

### 各層の役割
- **ドメイン層**: ビジネスロジックとエンティティ
- **ユースケース層**: アプリケーションのビジネスルール
- **ハンドラー層**: HTTPリクエストの処理
- **DTO層**: APIレスポンスの構造

## セットアップ

### 前提条件

- Go 1.21以上
- Air (ホットリロード用)
- Wire (依存注入用)

### インストール

```bash
# 依存関係のインストール
go mod tidy

# Wireのインストール
go install github.com/google/wire/cmd/wire@latest

# Airのインストール
go install github.com/air-verse/air@latest

# Wireコードの生成
wire ./internal/di
```

## 使用方法

### 通常の実行

```bash
go run cmd/main.go
```

### ホットリロードでの実行

```bash
air
```

### APIテスト

```bash
# Hello Worldエンドポイントのテスト
curl http://localhost:8081/hello
```

## モジュール構成

### Helloモジュール

- **ドメイン層**: Helloエンティティとドメインサービス
- **ユースケース層**: Helloのビジネスロジック
- **ハンドラー層**: HTTPリクエストの処理
- **DTO層**: APIレスポンスの構造

## APIエンドポイント

### GET /hello

Hello Worldメッセージを返します。

**レスポンス例:**
```json
{
  "message": "Hello, World!",
  "timestamp": "2024-01-01T00:00:00Z"
}
```

## OpenAPI構成

プロジェクトでは構造化されたOpenAPI構成を採用しています：

### ファイル構成
- `openapi/openapi.yaml` - メインのOpenAPIファイル
- `openapi/schemas/` - スキーマ定義
- `openapi/components/` - 共通コンポーネント（レスポンス、パラメータ）

### 新しいエンドポイントの追加手順
1. `openapi/schemas/`に新しいスキーマを追加
2. `openapi/components/`に共通レスポンスを追加（必要に応じて）
3. `openapi/openapi.yaml`にパスを追加
4. 対応するモジュールのハンドラーを実装

## 開発

### 新しいモジュールの追加

1. `internal/modules/`に新しいモジュールディレクトリを作成
2. ドメイン層（entity, service, repository）を実装
3. ユースケース層を実装
4. ハンドラー層を実装
5. DTO層を実装
6. `internal/di/wire.go`に依存関係を追加
7. `wire ./internal/di`でコードを生成

### 新しいエンドポイントの追加

1. `openapi/openapi.yaml`にエンドポイントを定義
2. 対応するモジュールのハンドラーにメソッドを追加
3. `internal/shared/interface/router/router.go`にルーティングを追加

### ホットリロード

Airを使用することで、ファイルの変更を検知して自動的にサーバーを再起動します。

## Makefileコマンド

### 基本コマンド
```bash
make help          # ヘルプを表示
make run           # アプリケーションを実行（依存関係とWireコード生成を含む）
make dev           # ホットリロードで開発サーバーを起動（依存関係とWireコード生成を含む）
make build         # アプリケーションをビルド（依存関係とWireコード生成を含む）
make test          # テストを実行（依存関係を含む）
make clean         # ビルドファイルを削除
```

### 開発用コマンド
```bash
make dev-setup     # 開発環境のセットアップ（依存関係、ツール、Wireコード生成）
make dev-start     # 開発サーバーを起動（セットアップから実行まで一括）
make dev-restart   # 開発サーバーを再起動（クリーンから実行まで一括）
make debug         # デバッグモードで実行
```

### 本番用コマンド
```bash
make prod-build    # 本番用ビルド（依存関係、Wireコード生成、ビルド）
make prod-run      # 本番用実行（依存関係、Wireコード生成、実行）
```

### ユーティリティコマンド
```bash
make wire          # Wireコードを生成
make deps          # 依存関係をインストール
make install-tools # 必要なツールをインストール
make setup         # プロジェクトの初期セットアップ
make api-test      # APIテストを実行
make new-module    # 新しいモジュールを作成
make check-deps    # 依存関係の状態を確認
make status        # プロジェクトの状態を確認
make lint          # コードの静的解析を実行
make format        # コードをフォーマット
```

### 推奨開発フロー
```bash
# 初回セットアップ
make setup

# 日常的な開発
make dev-start     # 開発サーバーを起動（依存関係とWireコード生成を含む）

# 新しいモジュール追加時
make new-module MODULE_NAME=user
# wire.goを編集
make wire

# プロジェクト状態確認
make status
```

## CI/CD

### ビルド手順

CI/CDパイプラインでは以下の手順でビルドを行います：

```bash
# 1. 依存関係のインストール
go mod download

# 2. Wireコードの生成
go install github.com/google/wire/cmd/wire@latest
wire ./internal/di

# 3. テストの実行
go test ./...

# 4. アプリケーションのビルド
go build -o bin/main cmd/main.go
```

### 生成ファイルの管理

以下のファイルは生成されるため、Gitの対象外としています：
- `internal/di/wire_gen.go` - Wireで生成される依存注入コード
- `bin/` - ビルド成果物
- `tmp/` - Airの一時ファイル

### GitHub Actions例

```yaml
name: Build and Test

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up Go
      uses: actions/setup-go@v4
      with:
        go-version: '1.21'
    
    - name: Install dependencies
      run: go mod download
    
    - name: Install Wire
      run: go install github.com/google/wire/cmd/wire@latest
    
    - name: Generate Wire code
      run: wire ./internal/di
    
    - name: Run tests
      run: go test ./...
    
    - name: Build
      run: go build -o bin/main cmd/main.go
```

## DDDの利点

- **ドメインの独立性**: 各モジュールが独立して管理できる
- **スケーラビリティ**: 新しいモジュールの追加が容易
- **チーム開発**: モジュールごとにチーム分けが可能
- **テスト**: モジュールごとにテストが書きやすい
- **保守性**: ドメインロジックが明確に分離されている