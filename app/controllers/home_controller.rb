class HomeController < ApplicationController
  include BestScoreLoadable
  before_action :set_best_score, only: [ :index ]

  def index
    @today_game = GameType.find_by(name: "hiragana_calc")

    if user_signed_in?
      # 全スコアを1回だけ取得（ループの外）
      all_scores = current_user.scores.order(played_on: :asc).to_a

      @chart_data = GameType.all.each_with_object({}) do |gt, hash|
        # DBに行かず、取得済みのall_scoresから選ぶだけ
        scores = all_scores.select { |s| s.game_type_id == gt.id }.last(10)

        hash[gt.display_name] = {
          labels: scores.map { |s| s.played_on.strftime("%-m/%-d") },
          datasets: [ { data: scores.map(&:score) } ]
        }
      end
    end
  end
end
