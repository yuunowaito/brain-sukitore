FactoryBot.define do
  factory :score do
    association :user
    association :game_type
    score { Faker::Number.between(from: 0, to: 100) }
    played_on { Date.today }
  end
end
