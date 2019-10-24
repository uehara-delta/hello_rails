# coding: utf-8
require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:entry) { FactoryBot.create(:entry) }

  it "bodyがあり、entryとuserに属していれば有効な状態であること" do
    comment = entry.comments.new(body: "新しいコメント", user: user)
    expect(comment).to be_valid
  end

  it "bodyがなければ無効な状態であること" do
    comment = entry.comments.new(body: nil, user: user)
    comment.valid?
    expect(comment.errors).to be_of_kind(:body, :blank)
  end

  it "entryに属していなければ無効な状態であること" do
    comment = Comment.new(body: "新しいコメント", user: user)
    comment.valid?
    expect(comment.errors).to be_of_kind(:entry, :blank)
  end

  it "userに属していなければ無効な状態であること" do
    comment = entry.comments.new(body: "新しいコメント", user: nil)
    comment.valid?
    expect(comment.errors).to be_of_kind(:user, :blank)
  end
end
