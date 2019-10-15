# coding: utf-8
require 'rails_helper'

RSpec.describe Blog, type: :model do
  it "titleがあれば有効な状態であること" do
    blog = Blog.new(title: "有効なブログ")
    expect(blog).to be_valid
  end

  it "titleがなければ無効な状態であること" do
    blog = Blog.new(title: nil)
    blog.valid?
    expect(blog.errors).to be_of_kind(:title, :blank)
  end
end
