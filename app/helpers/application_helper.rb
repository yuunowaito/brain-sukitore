module ApplicationHelper
  def default_meta_tags
    {
      site: "脳のスキトレ",
      title: "過去の自分を超える脳トレアプリ",
      reverse: true,
      charset: "utf-8",
      description: "ひらがな計算・色じゃんけん・色マス記憶で脳をトレーニング。スコアを記録して成長を実感しよう。",
      canonical: request.original_url,
      separator: "|",
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: "website",
        url: request.original_url,
        image: image_url("ogp.png"),
        local: "ja-JP"
      },
      twitter: {
        card: "summary_large_image",
        image: image_url("ogp.png")
      }
    }
  end
end
