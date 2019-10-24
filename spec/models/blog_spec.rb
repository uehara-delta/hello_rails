# coding: utf-8
require 'rails_helper'

RSpec.describe Blog, type: :model do
  let(:user) { FactoryBot.create(:user) }

  it "titleがありuserに属していれば有効な状態であること" do
    blog = user.blogs.build(title: "有効なブログ")
    expect(blog).to be_valid
  end

  it "titleがなければ無効な状態であること" do
    blog = user.blogs.build(title: nil)
    blog.valid?
    expect(blog.errors).to be_of_kind(:title, :blank)
  end

  it "userに属してなければ無効な状態であること" do
    blog = Blog.new(title: "タイトル", user: nil)
    blog.valid?
    expect(blog.errors).to be_of_kind(:user, :blank)
  end
end
