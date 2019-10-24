# coding: utf-8
require 'rails_helper'

RSpec.describe 'Entry管理', type: :system do
  context "ユーザーがログインしている場合" do
    let(:user) { FactoryBot.create(:user) }
    let(:blog) { FactoryBot.create(:blog) }

    scenario 'Entryの新規作成時にtitleを入力しなかった場合にエラーが表示されること' do
      sign_in user

      visit blog_path(blog)
      click_link 'New Entry'
      fill_in :'本文', with: 'body'

      expect {
        click_button '登録'
      }.to_not change(Entry, :count)
      expect(page).to have_content "Titleを入力してください"
    end

    scenario 'Entryの新規作成時にbodyを入力しなかった場合にエラーが表示されること' do
      sign_in user

      visit blog_path(blog)
      click_link 'New Entry'
      fill_in :'タイトル', with: 'title'

      expect {
        click_button '登録'
      }.to_not change(Entry, :count)
      expect(page).to have_content "Bodyを入力してください"
    end

    scenario 'Entryの新規作成時にtitleとbodyを入力した場合はデータが保存され閲覧画面に遷移すること' do
      sign_in user

      visit blog_path(blog)
      click_link 'New Entry'
      fill_in :'タイトル', with: '新しいタイトル'
      fill_in :'本文', with: '新しい内容'

      expect {
        click_button '登録'
      }.to change(Entry, :count).by(1)
      aggregate_failures do
        expect(current_path).to eq blog_entry_path(blog, blog.entries.last)
        expect(page).to have_content "Entry was successfully created."
        expect(page).to have_content "新しいタイトル"
        expect(page).to have_content "新しい内容"
      end
    end

    scenario 'Blogの閲覧画面に関連するEntryの一覧が表示されること' do
      FactoryBot.create(:entry, title: "エントリ1", blog: blog)
      FactoryBot.create(:entry, title: "エントリ2", blog: blog)
      FactoryBot.create(:entry, title: "エントリ3")

      visit blog_path(blog)

      aggregate_failures do
        expect(page).to have_content "エントリ1"
        expect(page).to have_content "エントリ2"
        expect(page).to_not have_content "エントリ3"
      end
    end

    scenario 'Blogの閲覧画面からEntryの閲覧画面に遷移できること' do
      FactoryBot.create(:entry, title: "エントリ1", blog: blog)
      entry = FactoryBot.create(:entry, title: "目的のエントリ", blog: blog)
      FactoryBot.create(:comment, body: "目的のコメント", entry: entry, status: 'approved')

      visit blog_path(blog)
      within("#entry-row-#{entry.id}") do
        click_link 'Show'
      end

      aggregate_failures do
        expect(current_path).to eq blog_entry_path(blog, entry)
        expect(page).to have_content "目的のエントリ"
        expect(page).to have_content "目的のコメント"
      end
    end

    scenario 'Blogの閲覧画面からEntryの編集画面に遷移し、編集ができること' do
      entry = FactoryBot.create(:entry, title: "目的のエントリ", blog: blog)
      FactoryBot.create(:entry, title: "エントリ2", blog: blog)

      sign_in user

      visit blog_path(blog)
      within("#entry-row-#{entry.id}") do
        click_link 'Edit'
      end

      expect(current_path).to eq edit_blog_entry_path(blog, entry)

      fill_in :'タイトル', with: "変更後のタイトル"
      fill_in :'本文', with: "変更後の内容"
      click_button '更新'

      aggregate_failures do
        expect(current_path).to eq blog_entry_path(blog, entry)
        expect(page).to have_content "Entry was successfully updated."
        expect(page).to have_content "変更後のタイトル"
        expect(page).to have_content "変更後の内容"
      end
    end

    scenario 'Blogの閲覧画面からEntryを削除できること' do
      entry = FactoryBot.create(:entry, title: "目的のエントリ", blog: blog)
      FactoryBot.create(:entry, title: "エントリ2", blog: blog)

      sign_in user

      visit blog_path(blog)
      expect(page).to have_content "目的のエントリ"

      expect {
        within "#entry-row-#{entry.id}" do
          page.accept_confirm 'Are you sure?' do
            click_link 'Destroy'
          end
        end
        expect(current_path).to eq blog_path(blog)
      }.to change(Entry, :count).by(-1)

      aggregate_failures do
        expect(page).to have_content "Entry was successfully destroyed."
        expect(page).to_not have_content "目的のエントリ"
      end
    end

    scenario 'Entryの閲覧画面からEntryの編集画面に遷移し、編集ができること' do
      entry = FactoryBot.create(:entry, title: "目的のエントリ", blog: blog)
      FactoryBot.create(:comment, entry: entry)

      sign_in user

      visit blog_entry_path(blog, entry)
      click_link 'entry-edit-link'

      expect(current_path).to eq edit_blog_entry_path(blog, entry)

      fill_in :'タイトル', with: "変更後のタイトル"
      fill_in :'本文', with: "変更後の内容"
      click_button '更新'

      aggregate_failures do
        expect(current_path).to eq blog_entry_path(blog, entry)
        expect(page).to have_content "Entry was successfully updated."
        expect(page).to have_content "変更後のタイトル"
        expect(page).to have_content "変更後の内容"
      end
    end
  end

  context "ユーザーがログインしていない場合" do
    let(:blog) { FactoryBot.create(:blog) }
    let(:entry) { FactoryBot.create(:entry, blog: blog) }

    scenario 'Blogの閲覧画面にEntryの新規作成リンクが表示されないこと' do
      visit blog_path(blog)

      expect(page).not_to have_link 'New Entry'
    end

    scenario 'Blogの閲覧画面にEntryの編集と削除のリンクが表示されないこと' do
      entry_id = entry.id

      visit blog_path(blog)

      aggregate_failures do
        within "#entry-row-#{entry_id}" do
          expect(page).to have_link 'Show'
          expect(page).not_to have_link 'Edit'
          expect(page).not_to have_link 'Destroy'
        end
      end
    end

    scenario 'Entryの閲覧画面にEntryの編集リンクが表示されないこと' do
      visit blog_entry_path(blog, entry)

      expect(page).not_to have_link 'Edit'
    end

    scenario 'Entryの編集ページへの遷移がエラーになること' do
      visit edit_blog_entry_path(blog, entry)

      aggregate_failures do
        expect(current_path).to eq root_path
        expect(page).to have_selector ".alert.alert-warning"
      end
    end
  end
end
