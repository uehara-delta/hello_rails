# coding: utf-8
require 'rails_helper'

RSpec.describe 'Blog管理', type: :system do

  context "ユーザーがログインしている場合" do
    let(:user) { FactoryBot.create(:user) }

    scenario 'Blogの新規作成時にtitleを入力しなかった場合にエラーが表示されること' do
      sign_in user

      visit blogs_path
      click_link 'New Blog'

      expect {
        click_button '登録'
      }.to_not change(Blog, :count)
      expect(page).to have_content "Titleを入力してください"
    end

    scenario 'Blogの新規作成時にtitleを入力した場合はデータが保存され閲覧画面に遷移すること' do
      sign_in user

      visit blogs_path
      click_link 'New Blog'
      fill_in :'タイトル', with: 'title'

      expect {
        click_button '登録'
      }.to change(Blog, :count).by(1)
      aggregate_failures do
        expect(current_path).to eq blog_path(Blog.last)
        expect(page).to have_content 'Blog was successfully created.'
      end
    end

    scenario 'Blogの一覧にTitleと作成者が表示されること' do
      blog = FactoryBot.create(:blog, title: "新しいブログ", user: user)

      sign_in user

      visit blogs_path

      aggregate_failures do
        within "#blog-row-#{blog.id}" do
          expect(page).to have_content blog.title
          expect(page).to have_content blog.user.name
        end
      end
    end

    scenario 'Blogの一覧からBlogの閲覧画面に遷移できること' do
      FactoryBot.create(:blog, title: "1つ目のブログ")
      blog = FactoryBot.create(:blog, title: "目的のブログ", user: user)
      entry = FactoryBot.create(:entry, blog: blog, title: '目的のエントリー')

      sign_in user

      visit blogs_path
      within "#blog-row-#{blog.id}" do
        click_link 'Show'
      end

      aggregate_failures do
        expect(current_path).to eq blog_path(blog)
        expect(page).to have_content "目的のブログ"
        expect(page).to have_content "目的のエントリー"
      end
    end

    scenario 'Blogの一覧からBlogの編集画面に遷移し、編集ができること' do
      blog = FactoryBot.create(:blog, title: "目的のブログ", user: user)
      FactoryBot.create(:blog, title: "2つ目のブログ")

      sign_in user

      visit blogs_path
      within "#blog-row-#{blog.id}" do
        click_link 'Edit'
      end

      expect(current_path).to eq edit_blog_path(blog)

      fill_in :'タイトル', with: "変更後のタイトル"
      click_button '更新'

      aggregate_failures do
        expect(current_path).to eq blog_path(blog)
        expect(page).to have_content "Blog was successfully updated."
        expect(page).to have_content "変更後のタイトル"
        expect(blog.reload.title).to eq "変更後のタイトル"
      end
    end

    scenario 'Blogの一覧からBlogを削除できること', js: true do
      blog = FactoryBot.create(:blog, title: "目的のブログ", user: user)
      FactoryBot.create(:blog, title: "2つ目のブログ")

      sign_in user

      visit blogs_path

      expect(page).to have_content "目的のブログ"

      expect {
        within "#blog-row-#{blog.id}" do
          page.accept_confirm 'Are you sure?' do
            click_link 'Destroy'
          end
        end
        expect(current_path).to eq blogs_path
      }.to change(Blog, :count).by(-1)

      aggregate_failures do
        expect(page).to have_content "Blog was successfully destroyed."
        expect(page).to_not have_content "目的のブログ"
      end
    end

    scenario 'Blogの閲覧画面からBlogの編集画面に遷移し、編集ができること' do
      blog = FactoryBot.create(:blog, title: "目的のブログ", user: user)
      FactoryBot.create(:entry, blog: blog)

      sign_in user

      visit blog_path(blog)
      click_link 'blog-edit-link'

      expect(current_path).to eq edit_blog_path(blog)

      fill_in :'タイトル', with: "変更後のタイトル"
      click_button '更新'

      aggregate_failures do
        expect(current_path).to eq blog_path(blog)
        expect(page).to have_content "Blog was successfully updated."
        expect(page).to have_content "変更後のタイトル"
        expect(blog.reload.title).to eq "変更後のタイトル"
      end
    end
  end

  context "ユーザーがログインしていない場合" do
    scenario "Blogの一覧画面にBlogの新規作成リンクが表示されないこと" do
      visit blogs_path

      expect(page).not_to have_link "New Blog"
    end

    scenario 'Blogの一覧にTitleと作成者が表示されること' do
      blog = FactoryBot.create(:blog, title: "新しいブログ")

      visit blogs_path

      aggregate_failures do
        within "#blog-row-#{blog.id}" do
          expect(page).to have_content blog.title
          expect(page).to have_content blog.user.name
        end
      end
    end

    scenario "Blogの一覧画面にBlogの編集と削除のリンクが表示されないこと" do
      FactoryBot.create(:blog)

      visit blogs_path

      aggregate_failures do
        expect(page).to have_link "Show"
        expect(page).not_to have_link "Edit"
        expect(page).not_to have_link "Destroy"
      end
    end

    scenario 'Blogの一覧からBlogの閲覧画面に遷移できること' do
      FactoryBot.create(:blog, title: "1つ目のブログ")
      blog = FactoryBot.create(:blog, title: "目的のブログ")
      entry = FactoryBot.create(:entry, blog: blog, title: '目的のエントリー')

      visit blogs_path
      within "#blog-row-#{blog.id}" do
        click_link 'Show'
      end

      aggregate_failures do
        expect(current_path).to eq blog_path(blog)
        expect(page).to have_content "目的のブログ"
        expect(page).to have_content "目的のエントリー"
      end
    end

    scenario "Blogの閲覧画面にBlogの編集リンクが表示されないこと" do
      blog = FactoryBot.create(:blog)

      visit blog_path(blog)

      expect(page).not_to have_link "Edit"
    end

    scenario "Blogの新規作成ページへの遷移がエラーになること" do
      visit new_blog_path

      aggregate_failures do
        expect(current_path).to eq root_path
        expect(page).to have_selector ".alert.alert-warning"
      end
    end

    scenario "Blogの編集ページへの遷移がエラーになること" do
      blog = FactoryBot.create(:blog)

      visit edit_blog_path(blog)

      aggregate_failures do
        expect(current_path).to eq root_path
        expect(page).to have_selector ".alert.alert-warning"
      end
    end
  end

  context "ログインユーザーとは異なるユーザーが作成したブログがある場合" do
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:user) }
    let(:my_blog) { FactoryBot.create(:blog, user: user) }
    let(:others_blog) { FactoryBot.create(:blog, user: other_user) }

    scenario 'Blogの一覧に作成者の名前とログインユーザーの権限にあったリンクが表示されること' do
      my_blog_id = my_blog.id
      others_blog_id = others_blog.id

      sign_in user

      visit blogs_path

      aggregate_failures do
        within "#blog-row-#{my_blog_id}" do
          expect(page).to have_content user.name
          expect(page).to have_link 'Show'
          expect(page).to have_link 'Edit'
          expect(page).to have_link 'Destroy'
        end
        within "#blog-row-#{others_blog_id}" do
          # 異なるユーザーが作成したブログには Edit と Destroy のリンクが表示されない
          expect(page).to have_content other_user.name
          expect(page).to have_link 'Show'
          expect(page).not_to have_link 'Edit'
          expect(page).not_to have_link 'Destroy'
        end
      end
    end

    scenario '異なるユーザーが作成したBlogの閲覧画面にBlogの編集リンクが表示されないこと' do
      sign_in user

      visit blog_path(others_blog)

      expect(page).not_to have_link "Edit"
    end

    scenario '異なるユーザーが作成したBlogの編集ページへの遷移がエラーになること' do
      sign_in user

      visit edit_blog_path(others_blog)

      aggregate_failures do
        expect(current_path).to eq root_path
        expect(page).to have_selector ".alert.alert-warning"
      end
    end
  end
end
