class GamesController < ApplicationController
  include BestScoreLoadable
  before_action :set_best_score, only: [ :result ]

  def index
    @game_type = GameType.find_by!(name: "hiragana_calc")
  end

  def show
    @question = QuestionGenerator.generate
    session[:score] = 0
  end

  def answer
    correct = params[:selected].to_i == params[:answer].to_i
    session[:score] = (session[:score] || 0) + 1 if correct

    @question = QuestionGenerator.generate
    render json: {
      correct: correct,
      score: session[:score] || 0,
      question: @question
    }
  end

  def result
    @score = session[:score] || 0
    save_score if user_signed_in?
  end

  private

  def save_score
    game_type = GameType.find_by!(name: "hiragana_calc")
    Score.create!(
      user: current_user,
      game_type: game_type,
      score: @score,  # ← ここで使う
      played_on: Time.current.in_time_zone("Tokyo").to_date
    )
  end
end
