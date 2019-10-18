FactoryBot.define do
  factory :user do
    name { "test user" }
    email { "test@example.com" }

    factory :user_with_avatar do
      avatar { Rack::Test::UploadedFile.new(Rails.root.join('spec/files/sample_avatar.jpg'), 'image/jpeg') }
    end
  end
end
