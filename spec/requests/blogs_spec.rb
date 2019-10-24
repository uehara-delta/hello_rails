# coding: utf-8
require 'rails_helper'

RSpec.describe "Blog管理", type: :request do

  context "ユーザーがログインしていない場合" do
    it "Blogの新規作成がエラーになること" do
      blog_params = FactoryBot.attributes_for(:blog)

      expect {
        post blogs_path, params: { blog: blog_params }
      }.not_to change { Blog.count }

      expect(response).to redirect_to root_path
      follow_redirect!
      expect(response.body).to include('alert alert-warning')
    end

    it "Blogの変更がエラーになること" do
      blog = FactoryBot.create(:blog)
      old_title = blog.title

      patch blog_path(blog), params: { blog: { title: '変更後のタイトル' } }
      expect(blog.reload.title).to eq old_title

      expect(response).to redirect_to root_path
      follow_redirect!
      expect(response.body).to include('alert alert-warning')
    end

    it "Blogの削除がエラーになること" do
      blog = FactoryBot.create(:blog)

      expect {
        delete blog_path(blog)
      }.not_to change { Blog.count }

      expect(response).to redirect_to root_path
      follow_redirect!
      expect(response.body).to include('alert alert-warning')
    end
  end

  context "ログインユーザーとは異なるユーザーが作成したブログの場合" do
    let!(:user) { FactoryBot.create(:user) }
    let!(:other_user) { FactoryBot.create(:user) }
    let!(:others_blog) { FactoryBot.create(:blog, user: other_user) }

    it "Blogの変更がエラーになること" do
      old_title = others_blog.title

      sign_in user

      patch blog_path(others_blog), params: { blog: { title: '変更後のタイトル' } }
      expect(others_blog.reload.title).to eq old_title

      expect(response).to redirect_to root_path
      follow_redirect!
      expect(response.body).to include('alert alert-warning')
    end

    it "Blogの削除がエラーになること" do
      sign_in user

      expect {
        delete blog_path(others_blog)
      }.not_to change { Blog.count }

      expect(response).to redirect_to root_path
      follow_redirect!
      expect(response.body).to include('alert alert-warning')
    end
  end
end
