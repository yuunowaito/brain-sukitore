class GamesController < ApplicationController
  def index
    @game_type = GameType.find_by!(name: "hiragana_calc")
  end

  def show
    @question = QuestionGenerator.generate
  end
end
