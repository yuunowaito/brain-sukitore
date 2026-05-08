class HomeController < ApplicationController
  include BestScoreLoadable
  before_action :set_best_score, only: [ :index ]

  def index
    @today_game = GameType.find_by(name: "hiragana_calc")
  end
end
