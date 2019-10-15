# coding: utf-8
require 'rails_helper'

RSpec.describe User, type: :model do

  it "Googleの認証情報からユーザーを作成できる" do
    auth_hash = OmniAuth::AuthHash.new({ provider: "test", uid: "1111",
                                         info: { name: "test user", email: "test@example.com"},
                                         credentials: { token: "abc" } })
    user = nil
    expect {
      user = User.find_for_google(auth_hash)
    }.to change(User, :count).by(1)
    aggregate_failures do
      expect(user.name).to eq "test user"
      expect(user.email).to eq "test@example.com"
      expect(user.provider).to eq "test"
      expect(user.uid).to eq "1111"
      expect(user.token).to eq "abc"
    end
  end

  it "Googleで認証後、ユーザーが存在する場合はDB内のユーザー情報を使用する" do
    auth_hash = OmniAuth::AuthHash.new({ provider: "test", uid: "1111",
                                         info: { name: "test user", email: "test@example.com"},
                                         credentials: { token: "abc" } })
    User.create!(name: "db user", email: "test@example.com")
    user = nil
    expect {
      user = User.find_for_google(auth_hash)
    }.to_not change(User, :count)
    aggregate_failures do
      expect(user.name).to eq "db user"
      expect(user.email).to eq "test@example.com"
    end
  end
end
