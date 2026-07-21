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

### ユーザー登録 / ログイン

<p align="center">
  <a href="https://gyazo.com/3cbef2826b86205ce18236d094a5680c"><img src="https://i.gyazo.com/3cbef2826b86205ce18236d094a5680c.gif" width="600"></a>
</p>

<p align="left">『名前』『メールアドレス』『パスワード』を入力してユーザー登録を行います。また、Google・LINEアカウントを用いたログインも可能です。</p>
<br>

### ひらがな計算
<p align="center">
  <a href="https://gyazo.com/3df791f6ec114df9dc39c2532e864fec"><img src="https://i.gyazo.com/3df791f6ec114df9dc39c2532e864fec.gif" width="600"></a>
</p>

<p align="left">ひらがなで出題される計算問題（例：「いち たす に」）に対して、4つの選択肢の中から正しい答えを制限時間内で選んでいくゲームです。とっさの計算力と読解力を同時に鍛えられます。</p>
<br>

### 色じゃんけん
<p align="center">
  <a href="https://gyazo.com/d66808db7e4ffff0b626b5d343bbdcda"><img src="https://i.gyazo.com/d66808db7e4ffff0b626b5d343bbdcda.gif" width="600"></a>
</p>

<p align="left">制限時間内に、青い手が表示されたら「勝つ手」を、赤い手が表示されたら「負ける手」を3択の中から選んでいくゲームです。瞬時の判断力と、瞬発力を鍛えられます。</p>
<br>

### 色マス記憶
<p align="center">
  <a href="https://gyazo.com/de908f1ac94cfaf4e70a024e3d7170a0"><img src="https://i.gyazo.com/de908f1ac94cfaf4e70a024e3d7170a0.gif" width="600"></a>
</p>

<p align="left">制限時間内に、左側に表示されている見本のマスと同じ位置を、右側のグリッドでクリックして再現する脳トレです。瞬間的な記憶力と集中力を鍛えられます。</p>
<br>

### スコア推移グラフ
<p align="center">
  <a href="https://gyazo.com/2372ab73bd2d6b37f1158848cb8f1a7f"><img src="https://i.gyazo.com/2372ab73bd2d6b37f1158848cb8f1a7f.gif" width="600"></a>
</p>

<p align="left">ゲームごとのハイスコアとスコアの推移をグラフで確認できます。タブを切り替えることで、脳トレごとの成長を可視化できます。</p>
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
[![Image from Gyazo](https://i.gyazo.com/afbf76c4bf3154972b08e50868d457f9.png)](https://gyazo.com/afbf76c4bf3154972b08e50868d457f9)