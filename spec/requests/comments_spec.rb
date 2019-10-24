# coding: utf-8
require 'rails_helper'

RSpec.describe "Comment管理", type: :request do

  context "ユーザーがログインしていない場合" do
    let(:blog) { FactoryBot.create(:blog) }
    let(:entry) { FactoryBot.create(:entry, blog: blog) }

    it "Commentの新規作成がエラーになること" do
      comment_params = FactoryBot.attributes_for(:comment, entry: entry)

      expect {
        post blog_entry_comments_path(blog, entry), params: { comment: comment_params }
      }.not_to change { Comment.count }

      expect(response).to redirect_to root_path
      follow_redirect!
      expect(response.body).to include('alert alert-warning')
    end

    it "Commentの削除がエラーになること" do
      comment = FactoryBot.create(:comment, entry: entry)

      expect {
        delete blog_entry_comment_path(blog, entry, comment)
      }.not_to change { Comment.count }

      expect(response).to redirect_to root_path
      follow_redirect!
      expect(response.body).to include('alert alert-warning')
    end

    it "Commentの承認がエラーになること" do
      comment = FactoryBot.create(:comment, entry: entry, status: nil)
      old_status = comment.status

      put approve_blog_entry_comment_path(blog, entry, comment)
      expect(comment.reload.status).to eq old_status

      expect(response).to redirect_to root_path
      follow_redirect!
      expect(response.body).to include('alert alert-warning')
    end
  end

  context "ログインユーザーとは異なるユーザーが作成したブログの場合" do
    let!(:user) { FactoryBot.create(:user) }
    let!(:other_user) { FactoryBot.create(:user) }
    let!(:others_blog) { FactoryBot.create(:blog, user: other_user) }
    let!(:entry) { FactoryBot.create(:entry, blog: others_blog) }
    let!(:comment) { FactoryBot.create(:comment, entry: entry) }

    it "Commentの削除がエラーになること" do
      sign_in user

      expect {
        delete blog_entry_comment_path(others_blog, entry, comment)
      }.not_to change { Comment.count }

      expect(response).to redirect_to root_path
      follow_redirect!
      expect(response.body).to include('alert alert-warning')
    end

    it "Commentの承認がエラーになること" do
      old_status = comment.status

      sign_in user

      put approve_blog_entry_comment_path(others_blog, entry, comment)
      expect(comment.reload.status).to eq old_status

      expect(response).to redirect_to root_path
      follow_redirect!
      expect(response.body).to include('alert alert-warning')
    end
  end
end
