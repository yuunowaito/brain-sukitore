# プロジェクト名：『脳のスキトレ』
<br>

# 目次
- [サービス概要](#-サービス概要)
- [サービスURL](#-サービスurl)
- [サービス開発の背景](#-サービス開発の背景)
- [機能紹介](#-機能紹介)
- [技術構成について](#-技術構成について)
  - [使用技術](#使用技術)
  - [テーブル構成](#テーブル構成)
<br>

# 🧠 サービス概要
〜 スマホひとつで、いつでもどこでも脳トレ 〜<br>
<br>

『脳のスキトレ』は、1回30秒ほどでサッと取り組める脳トレゲームで、プレイするとスコアが記録され、その推移をグラフで確認できるアプリです。<br>
「過去の自分を超える体験」をコンセプトに、成長を実感しながら続けられる点にこだわっています。<br>
<br>

# 🌏 サービスURL
### https://brain-sukitore.com<br>
<br>

# 📖 サービス開発の背景
もともとは脳トレが好きな親に向けて作ったアプリです。<br>
本の脳トレだと鉛筆が必要だったり、場所を取ったりしますが、これならスマホやパソコン一つあれば、いつでもどこでも手軽に脳トレができます。<br>
<br>

1回30秒ほどでサッと取り組めるゲームをいくつか用意し、プレイするとスコアが記録され、その推移をグラフで見られるようにしました。<br>
「過去の自分を超える体験」ができることで、成長を実感しながら継続できるアプリを目指しています。<br>
<br>

# 💻 機能紹介

| ユーザー登録 / ログイン |
| :---: |
| <a href="https://gyazo.com/3cbef2826b86205ce18236d094a5680c"><img src="https://i.gyazo.com/3cbef2826b86205ce18236d094a5680c.gif" width="500"></a> |
| <p align="left">『名前』『メールアドレス』『パスワード』を入力してユーザー登録を行います。また、Google・LINEアカウントを用いたログインも可能です。</p> |
<br>

| ひらがな計算 |
| :---: |
| <a href="https://gyazo.com/3df791f6ec114df9dc39c2532e864fec"><img src="https://i.gyazo.com/3df791f6ec114df9dc39c2532e864fec.gif" width="500"></a> |
| <p align="left">表示された計算問題に、制限時間内で答えていくゲームです。</p> |
<br>

| 色じゃんけん |
| :---: |
| [![Image from Gyazo](https://i.gyazo.com/ここにID.gif)](https://gyazo.com/ここにID) |
| <p align="left">ひらがなで出題される計算問題（例：「いち たす に」）に対して、4つの選択肢の中から正しい答えを制限時間内で選んでいくゲームです。とっさの計算力と読解力を同時に鍛えられます。</p> |
<br>

| 色マス記憶 |
| :---: |
| [![Image from Gyazo](https://i.gyazo.com/ここにID.gif)](https://gyazo.com/ここにID) |
| <p align="left">一瞬表示されるマスの位置を記憶し、同じ位置を再現するゲームです。</p> |
<br>

| スコア推移グラフ |
| :---: |
| [![Image from Gyazo](https://i.gyazo.com/ここにID.gif)](https://gyazo.com/ここにID) |
| <p align="left">ゲームごとのスコア推移をグラフで確認できます。タブを切り替えることで、各ゲームの成長を可視化できます。</p> |
<br>

# 🔧 技術構成について

## 使用技術
| カテゴリ | 技術内容 |
| --- | --- |
| サーバーサイド | Ruby on Rails 7.2.3・Ruby |
| フロントエンド | Hotwire（Turbo・Stimulus）・Tailwind CSS・DaisyUI・Chart.js |
| 認証 | Devise・OmniAuth（Google・LINE） |
| 画像処理 | Active Storage・Cloudinary・libvips |
| データベース | PostgreSQL |
| インフラ | Docker（開発環境）・Render（本番） |
| テスト・CI | RSpec・GitHub Actions（RuboCop・Brakeman・RSpec） |
<br>

## テーブル構成
（ここにER図の画像、または説明文）