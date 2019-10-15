# coding: utf-8
require 'rails_helper'

RSpec.describe User, type: :model do

  it "nameとemailがあれば有効な状態であること" do
    user = User.new(name: "test user", email: "test@example.com")
    expect(user).to be_valid
  end

  it "nameがなければ無効な状態であること" do
    user = FactoryBot.build(:user, name: nil)
    user.valid?
    expect(user.errors).to be_of_kind(:name, :blank)
  end

  it "emailがなければ無効な状態であること" do
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors).to be_of_kind(:email, :blank)
  end

  it "sexが有効な選択肢であること" do
    expect(User.sex.values).to eq ["male", "female", "other", "rather_not_say"]
  end

  it "sexが選択肢外であれば無効な状態であること" do
    user = FactoryBot.build(:user, sex: 'boy')
    user.valid?
    expect(user.errors).to be_of_kind(:sex, :inclusion)
  end

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
