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
    if params[:game_type] == "color_grid"
      @score     = params[:score].to_i
      @game_type = GameType.find_by(name: "color_grid")
    else
      @score     = session[:score] || 0
      @game_type = GameType.find_by(name: session[:game_type])
      save_score if user_signed_in?
    end
  end

  def color_grid
  @game_type  = GameType.find_by!(name: "color_grid")
  @best_score = current_user&.scores
                  &.where(game_type: @game_type)
                  &.maximum(:score) || 0

  result       = ColorGridGenerator.generate(target_count: 3)
  @sample_grid = result[:sample].to_json
  @answer_grid = result[:answer].to_json
  end


  def color_grid_complete
    game_type    = GameType.find_by!(name: "color_grid")
    target_count = [[params[:target_count].to_i, 3].max, 5].min

    result = ColorGridGenerator.generate(target_count: target_count)

    if user_signed_in?
      current_user.scores.create!(
        game_type: game_type,
        score:     params[:score].to_i,
        played_on: Time.current.in_time_zone("Tokyo").to_date
      )
    end

    render json: {
      score:       params[:score].to_i,
      next_sample: result[:sample],
      next_answer: result[:answer]
    }
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
