# coding: utf-8
require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:blog) { FactoryBot.create(:blog) }
  let(:entry) { FactoryBot.create(:entry) }

  it "bodyがあり、entryに属していれば有効な状態であること" do
    comment = entry.comments.new(body: "新しいコメント")
    expect(comment).to be_valid
  end

  it "bodyがなければ無効な状態であること" do
    comment = entry.comments.new(body: nil)
    comment.valid?
    expect(comment.errors[:body]).to include("を入力してください")
  end

  it "entryに属していなければ無効な状態であること" do
    comment = Comment.new(body: "新しいコメント")
    comment.valid?
    expect(comment.errors[:entry]).to include("を入力してください")
  end
end
