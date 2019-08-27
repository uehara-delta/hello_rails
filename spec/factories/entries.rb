# coding: utf-8
FactoryBot.define do
  factory :entry do
    title { "新しいエントリ" }
    body { "エントリの本文" }
    association :blog
  end
end
