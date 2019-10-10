FactoryBot.define do
  factory :user do
    email { "test@example.com" }
    password { "password" }
    confirmed_at { Date.today }
  end
end
