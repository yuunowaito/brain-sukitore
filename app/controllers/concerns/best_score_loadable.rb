module BestScoreLoadable
  extend ActiveSupport::Concern

  def set_best_score
    if user_signed_in?
      @best_score = Score.where(user: current_user).maximum(:score) || 0
    end
  end
end
