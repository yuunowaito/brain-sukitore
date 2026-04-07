class Score < ApplicationRecord
  belongs_to :user
  belongs_to :game_type

  validates :score, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :played_on, presence: true
end
