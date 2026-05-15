module BestScoreLoadable
  extend ActiveSupport::Concern

  def set_best_score
    if user_signed_in?
      scores = Score.where(user: current_user)
                    .group(:game_type_id)
                    .maximum(:score)
      @best_scores = GameType.all.map do |game_type|
        {
          name: game_type.display_name,
          score: scores[game_type.id] || 0
        }
      end
    end
  end
end
