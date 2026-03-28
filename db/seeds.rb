# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

GameType.find_or_create_by!(name: 'hiragana_calc') do |game_type|
  game_type.display_name = 'ひらがな計算'
  game_type.description = 'ひらがなで書かれた数式を解いて脳を鍛える脳トレです。'
end
