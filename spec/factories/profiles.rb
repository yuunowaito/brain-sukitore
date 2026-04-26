FactoryBot.define do
  factory :profile do
    name { Faker::Name.name }
    association :user
  end
end