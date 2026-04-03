class GamesController < ApplicationController
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
  end
end
