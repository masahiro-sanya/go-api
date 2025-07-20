# Go API Project

OpenAPI.yamlから取り込んでGoのAPIを作成するプロジェクトです。モジュラーDDD（Domain-Driven Design）アーキテクチャを採用しています。

## 技術スタック

- **フレームワーク**: Echo v4
- **ホットリロード**: Air
- **依存注入**: Wire
- **アーキテクチャ**: モジュラーDDD
- **API仕様**: OpenAPI 3.0

## アーキテクチャ

このプロジェクトはモジュラーDDDアーキテクチャを採用しています：

```
go-api/
├── cmd/
│   └── main.go                    # メインアプリケーション
├── internal/
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
│   ├── shared/                    # 共有
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
├── pkg/                           # 外部公開パッケージ
├── api/                           # OpenAPI仕様
└── docs/                          # ドキュメント
```

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

1. `openapi.yaml`にエンドポイントを定義
2. 対応するモジュールのハンドラーにメソッドを追加
3. `internal/shared/interface/router/router.go`にルーティングを追加

### ホットリロード

Airを使用することで、ファイルの変更を検知して自動的にサーバーを再起動します。

## DDDの利点

- **ドメインの独立性**: 各モジュールが独立して管理できる
- **スケーラビリティ**: 新しいモジュールの追加が容易
- **チーム開発**: モジュールごとにチーム分けが可能
- **テスト**: モジュールごとにテストが書きやすい
- **保守性**: ドメインロジックが明確に分離されている