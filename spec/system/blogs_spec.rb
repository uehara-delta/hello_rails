# coding: utf-8
require 'rails_helper'

RSpec.describe 'Blog管理', type: :system do
  scenario 'Blogの新規作成時にtitleを入力しなかった場合にエラーが表示されること' do
    visit blogs_path
    click_link 'New Blog'

    expect {
      click_button '登録'
    }.to_not change(Blog, :count)
    expect(page).to have_content "Titleを入力してください"
  end

  scenario 'Blogの新規作成時にtitleを入力した場合はデータが保存され閲覧画面に遷移すること' do
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

  scenario 'Blogの一覧からBlogの編集画面に遷移し、編集ができること' do
    blog = FactoryBot.create(:blog, title: "目的のブログ")
    FactoryBot.create(:blog, title: "2つ目のブログ")

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

  scenario 'Blogの一覧からBlogを削除できること' do
    blog = FactoryBot.create(:blog, title: "目的のブログ")
    FactoryBot.create(:blog, title: "2つ目のブログ")

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
    blog = FactoryBot.create(:blog, title: "目的のブログ")
    FactoryBot.create(:entry, blog: blog)

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
