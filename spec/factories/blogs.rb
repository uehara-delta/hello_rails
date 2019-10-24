# coding: utf-8
FactoryBot.define do
  factory :blog do
    title { "新しいブログ" }
    association :user
  end
end
