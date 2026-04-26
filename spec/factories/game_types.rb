FactoryBot.define do
  factory :game_type do
    name { Faker::Lorem.unique.word }
    display_name { Faker::Lorem.word }
  end
end
