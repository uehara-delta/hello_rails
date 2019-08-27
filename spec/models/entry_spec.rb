# coding: utf-8
require 'rails_helper'

RSpec.describe Entry, type: :model do
  it "titleとbodyがあり、blogに属していれば有効な状態であること" do
    blog = Blog.new(title: "テスト用ブログ")
    entry = blog.entries.new(title: "新しいエントリ", body: "エントリの本文")
    expect(entry).to be_valid
  end

  it "titleがなければ無効な状態であること" do
    blog = Blog.new(title: "テスト用ブログ")
    entry = blog.entries.new(title: nil, body: "エントリの本文")
    entry.valid?
    expect(entry.errors[:title]).to include("can't be blank")
  end

  it "bodyがなければ無効な状態であること" do
    blog = Blog.new(title: "テスト用ブログ")
    entry = blog.entries.new(title: "新しいエントリ", body: nil)
    entry.valid?
    expect(entry.errors[:body]).to include("can't be blank")
  end

  it "blogに属していなければ無効な状態であること" do
    entry = Entry.new(title: "新しいエントリ", body: "エントリの本文")
    entry.valid?
    expect(entry.errors[:blog]).to include("must exist")
  end
end
