class HomeController < ApplicationController
  include BestScoreLoadable
  before_action :set_best_score, only: [ :index ]

  def index
  end
end
