# coding: utf-8
FactoryBot.define do
  factory :comment do
    body { "コメントの内容" }
    association :entry
    association :user
  end
end
