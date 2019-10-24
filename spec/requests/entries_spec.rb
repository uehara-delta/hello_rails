# coding: utf-8
require 'rails_helper'

RSpec.describe "Entries", type: :request do

  context "ユーザーがログインしていない場合" do
    let(:blog) { FactoryBot.create(:blog) }

    it "Entryの新規作成がエラーになること" do
      entry_params = FactoryBot.attributes_for(:entry, blog: blog)

      expect {
        post blog_entries_path(blog), params: { entry: entry_params }
      }.not_to change { Entry.count }

      expect(response).to redirect_to root_path
      follow_redirect!
      expect(response.body).to include('alert alert-warning')
    end

    it "Entryの変更がエラーになること" do
      entry = FactoryBot.create(:entry, blog: blog)
      old_title = entry.title
      old_body = entry.body

      patch blog_entry_path(blog, entry), params: { entry: { title: '変更後のタイトル', body: '変更後の内容' } }
      entry.reload
      expect(entry.title).to eq old_title
      expect(entry.body).to eq old_body

      expect(response).to redirect_to root_path
      follow_redirect!
      expect(response.body).to include('alert alert-warning')
    end

    it "Entryの削除がエラーになること" do
      entry = FactoryBot.create(:entry, blog: blog)

      expect {
        delete blog_entry_path(blog, entry)
      }.not_to change { Entry.count }

      expect(response).to redirect_to root_path
      follow_redirect!
      expect(response.body).to include('alert alert-warning')
    end
  end

  context "ログインユーザーとは異なるユーザーが作成したブログの場合" do
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:user) }
    let(:others_blog) { FactoryBot.create(:blog, user: other_user) }

    it "Entryの新規作成がエラーになること" do
      entry_params = FactoryBot.attributes_for(:entry, blog: others_blog)

      sign_in user

      expect {
        post blog_entries_path(others_blog), params: { entry: entry_params }
      }.not_to change { Entry.count }

      expect(response).to redirect_to root_path
      follow_redirect!
      expect(response.body).to include('alert alert-warning')
    end

    it "Entryの変更がエラーになること" do
      entry = FactoryBot.create(:entry, blog: others_blog)
      old_title = entry.title
      old_body = entry.body

      patch blog_entry_path(others_blog, entry), params: { entry: { title: '変更後のタイトル', body: '変更後の内容' } }
      entry.reload
      expect(entry.title).to eq old_title
      expect(entry.body).to eq old_body

      expect(response).to redirect_to root_path
      follow_redirect!
      expect(response.body).to include('alert alert-warning')
    end

    it "Entryの削除がエラーになること" do
      entry = FactoryBot.create(:entry, blog: others_blog)

      expect {
        delete blog_entry_path(others_blog, entry)
      }.not_to change { Entry.count }

      expect(response).to redirect_to root_path
      follow_redirect!
      expect(response.body).to include('alert alert-warning')
    end
  end
end
