# coding: utf-8
require 'rails_helper'

RSpec.describe 'Blog管理', type: :system do
  scenario 'Blogの新規作成時にtitleを入力しなかった場合にエラーが表示されること' do
    visit blogs_path
    click_link 'New Blog'
    expect {
      click_button 'Save'
    }.to_not change(Blog, :count)
    expect(page).to have_content "Title can't be blank"
  end

  scenario 'Blogの新規作成時にtitleを入力した場合はデータが保存され閲覧画面に遷移すること' do
    visit blogs_path
    click_link 'New Blog'
    fill_in 'Title', with: 'title'
    expect {
      click_button 'Save'
    }.to change(Blog, :count).by(1)
    expect(current_path).to eq blog_path(Blog.last)
    expect(page).to have_content 'Blog was successfully created.'
  end
end
