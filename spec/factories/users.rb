FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 6) }

    after(:build) do |user|
      user.profile ||= build(:profile, user: user)
    end

    after(:create) do |user|
      user.profile || create(:profile, user: user)
    end
  end
end