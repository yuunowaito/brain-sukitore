class GameType < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :display_name, presence: true
end
