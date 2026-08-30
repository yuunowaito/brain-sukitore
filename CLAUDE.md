# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## ブランチ運用ルール

コード・ドキュメントを問わず、作業を始める前に必ず新しいブランチを切ってください。
`main` ブランチに直接コミットしないでください。

## 概要

『脳のスキトレ』(brain-sukitore.com) は、1回30秒ほどの脳トレゲームを集めた Rails 7.2
アプリです。ユーザーがプレイするとスコアが保存され、推移が Chart.js のグラフで表示
されます。フロントエンドは Hotwire (Turbo + Stimulus) と Tailwind v4 + DaisyUI で、
SPA フレームワークは使っていません。

## 開発環境

開発環境は Docker Compose 上での実行を前提としています。`config/database.yml` は
`compose.yml` に合わせて `host: db` と `password: password` をハードコードしています。

```bash
docker compose up          # Postgres 17 + web を起動（bundle install, db:prepare, bin/dev を実行）
```

`bin/dev` は `Procfile.dev` を実行します: Rails サーバー (port 3000)、
`yarn build --watch` (esbuild)、`yarn build:css --watch` (Tailwind CLI)。
Docker の外で動かす場合は `DATABASE_URL` を指定するか `config/database.yml` を
編集して DB のホスト・認証情報を上書きする必要があります。

シークレットは `.env`（`dotenv-rails` が読み込む）にあります: メール送信の認証情報、
Google/LINE の OAuth、Cloudinary。ゲーム一覧は `bin/rails db:seed` で投入します
（冪等。アプリが依存する 3 つの `GameType` レコードを作成）。

## よく使うコマンド

```bash
bundle exec rspec                              # テスト全体（CI が実行するのはこれ）
bundle exec rspec spec/models/score_spec.rb    # ファイル単位
bundle exec rspec spec/models/score_spec.rb:12 # 行番号で 1 example だけ
bin/rubocop                                    # Lint（rubocop-rails-omakase のスタイル）
bin/rubocop -a                                 # 自動修正
bin/brakeman --no-pager --except EOLRails      # セキュリティスキャン
bin/rails db:seed                              # GameType レコードを（再）作成
yarn build && yarn build:css                   # アセットの単発ビルド
```

CI (`.github/workflows/ci.yml`) は push/PR で 3 つのジョブを実行します: Brakeman、
RuboCop、RSpec（先に `rails db:test:prepare` と `assets:precompile` を実行）。

### テストスイートについて

`spec/`（RSpec + FactoryBot + Faker）と `test/`（Minitest、fixtures）の両方が存在
します。**アクティブなのは RSpec です** — CI が実行するのも、意味のあるカバレッジが
あるのも RSpec だけです。`test/` はほぼ scaffold の残骸なので、テストは spec に追加
してください。

## アーキテクチャ

### ゲームの流れ

ゲームは `GameType` モデルによるデータ駆動です（`name` が内部キー、`display_name` が
ユーザー向け表示名）。`GamesController` はゲームごとにコントローラを分けず、セッション
状態を使って全ゲームを統括します:

- `show` → ゲーム説明ページ
- `play` → `session[:score]`、`session[:game_type]` をリセットし、最初の問題を生成
- `answer` (POST, JSON) → 送信された回答を採点し、次の問題を返す。30 秒のタイマー中に
  Stimulus の `game_controller.js` から繰り返し呼ばれる
- `result` → `session[:score]` を読み、`user_signed_in?` なら `Score` を永続化

**「color_grid」（色マス記憶）は例外です**: セッションのスコアフローを使いません。
エンドポイント（`color_grid`、`color_grid_complete`）はスコアやグリッド状態を params で
明示的に渡し、`result` は `params[:game_type] == "color_grid"` で分岐します。
ゲームの流れに手を入れるときは両方の経路を確認してください。

### 問題ジェネレータ (`app/services/`)

各ゲームには問題の hash を返す素の Ruby クラスがあります。`GamesController::GENERATORS`
が `game_type.name` → ジェネレータ を対応付けます（セッションベースのゲーム用）:

- `QuestionGenerator` — ひらがな計算。数字/演算子とひらがなの変換は `HiraganaCalculator` に委譲
- `ColorJankenGenerator` — 色じゃんけん。連続を避けるため `previous_hand` を受け取る
- `ColorGridGenerator` — 色マス記憶。`GENERATORS` 経由ではなく直接呼び出す

ジェネレータは純粋で Rails に依存しないので、単体でテストできます。

### スコアとベストスコア表示

`Score` は `user` と `game_type` に belongs_to し、`played_on` は東京タイムゾーンの
日付です。`BestScoreLoadable` concern（`GamesController` に include）が、グループ化した
`maximum(:score)` クエリ 1 本で `@best_scores` を組み立てます。
`score_chart_controller.js` が Chart.js で履歴を描画します。

### 認証

Devise（`:database_authenticatable`, `:registerable`, `:recoverable`,
`:rememberable`, `:validatable`, `:omniauthable`）と Google/LINE の OAuth。
Devise のコントローラは `app/controllers/users/` 以下でサブクラス化しています。

- **LINE はカスタム OmniAuth ストラテジ**（`lib/omniauth/strategies/line.rb`。LINE は
  gem がない）。OIDC の `id_token` をサーバー側で検証し、リプレイ対策としてセッションの
  nonce を確認します。
- LINE は必ずしもメールアドレスを返しません。`Users::OmniauthCallbacksController#line`
  はメールが空なら auth データを `session["devise.line_data"]` に退避し、アカウント作成
  前にメールを入力させるため `line_email_setup` / `line_complete`（`config/routes.rb` の
  `devise_scope` にあるカスタムルート）へ誘導します。
- `User.from_omniauth` / `User.create_from_omniauth_with_email` にアカウント連携の
  ルール（検証済みメールでの照合、provider/uid の補完）があります。

### プロフィールとアバター

`User has_one :profile`（名前は `Profile` にあり、User で `delegate :name`）。
`Profile has_one_attached :avatar`（Active Storage）。画像は `ImageProcessable`
concern で処理され（libvips → リサイズ → WebP、上限 2 MB）、本番では Cloudinary に
保存されます。

## 規約

- RuboCop は `rubocop-rails-omakase` を使用 — **配列/ハッシュの括弧内にスペースを入れる**
  スタイル（`[ a, b ]`）です。意図的なものなので「修正」しないでください。
- `ApplicationController` の `allow_browser versions: :modern` — アプリはモダンブラウザ
  （WebP、CSS `:has` など）を前提にしています。
- ユーザー向け文字列や flash メッセージは日本語です（`rails-i18n` / `devise-i18n`）。
