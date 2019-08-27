# coding: utf-8
require 'rails_helper'

RSpec.describe Entry, type: :model do
  let(:blog) { FactoryBot.create(:blog) }

  it "titleとbodyがあり、blogに属していれば有効な状態であること" do
    entry = blog.entries.new(title: "新しいエントリ", body: "エントリの本文")
    expect(entry).to be_valid
  end

  it "titleがなければ無効な状態であること" do
    entry = FactoryBot.build(:entry, title: nil)
    entry.valid?
    expect(entry.errors[:title]).to include("を入力してください")
  end

  it "bodyがなければ無効な状態であること" do
    entry = FactoryBot.build(:entry, body: nil)
    entry.valid?
    expect(entry.errors[:body]).to include("を入力してください")
  end

  it "blogに属していなければ無効な状態であること" do
    entry = FactoryBot.build(:entry, blog_id: nil)
    entry.valid?
    expect(entry.errors[:blog]).to include("を入力してください")
  end
end
