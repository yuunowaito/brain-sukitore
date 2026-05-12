class GamesController < ApplicationController
  include BestScoreLoadable
  before_action :set_best_score, only: [ :result ]

  GENERATORS = {
    "hiragana_calc" => QuestionGenerator,
    "color_janken"  => ColorJankenGenerator
  }.freeze

  def show
    @game_type = GameType.find(params[:id])
  end

  def play
    @game_type = GameType.find(params[:id])
    session[:color_janken] = {}
    @question = GENERATORS[@game_type.name].generate
    session[:score] = 0
    session[:game_type] = @game_type.name
  end

  def answer
    game_type_name = session[:game_type]
    correct = if game_type_name == "hiragana_calc"
                params[:selected].to_i == params[:answer].to_i
    else
                params[:selected] == params[:answer]
    end
    session[:score] = (session[:score] || 0) + 1 if correct

    previous_hand = session.dig("color_janken", "previous_hand")
    @question = GENERATORS[session[:game_type]].generate(previous_hand)
    session[:color_janken][:previous_hand] = @question[:hand] if session[:game_type] == "color_janken"

    render json: {
      correct: correct,
      score: session[:score] || 0,
      question: @question
    }
  end

  def result
    @score = session[:score] || 0
    @game_type = GameType.find_by(name: session[:game_type])
    save_score if user_signed_in?
  end

  private

  def save_score
    game_type = GameType.find_by!(name: session[:game_type])
    Score.create!(
      user: current_user,
      game_type: game_type,
      score: @score,
      played_on: Time.current.in_time_zone("Tokyo").to_date
    )
  end
end
