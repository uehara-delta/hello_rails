# coding: utf-8
require 'rails_helper'

RSpec.describe Comment, type: :model do
  it "bodyがあり、entryに属していれば有効な状態であること" do
    blog = Blog.new(title: "テスト用ブログ")
    entry = blog.entries.new(title: "新しいエントリ", body: "エントリの本文")
    comment = entry.comments.new(body: "新しいコメント")
    expect(comment).to be_valid
  end

  it "bodyがなければ無効な状態であること" do
    blog = Blog.new(title: "テスト用ブログ")
    entry = blog.entries.new(title: "新しいエントリ", body: "エントリの本文")
    comment = entry.comments.new(body: nil)
    comment.valid?
    expect(comment.errors[:body]).to include("can't be blank")
  end

  it "entryに属していなければ無効な状態であること" do
    comment = Comment.new(body: "新しいコメント")
    comment.valid?
    expect(comment.errors[:entry]).to include("must exist")
  end
end
