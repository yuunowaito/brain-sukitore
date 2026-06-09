class HomeController < ApplicationController
  include BestScoreLoadable
  before_action :set_best_score, only: [ :index ]

  def index
    @today_game = GameType.find_by(name: "hiragana_calc")

    if user_signed_in?
      @chart_data = GameType.all.each_with_object({}) do |gt, hash|
        scores = current_user.scores
                            .where(game_type: gt)
                            .order(played_on: :asc)
                            .last(10)
        hash[gt.display_name] = {
          labels: scores.map { |s| s.played_on.strftime("%-m/%-d") },
          datasets: [ {
            data: scores.map(&:score)
          } ]
        }
      end
    end
  end
end
