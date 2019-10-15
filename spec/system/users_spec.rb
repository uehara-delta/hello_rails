# coding: utf-8
require 'rails_helper'

RSpec.describe 'User管理', type: :system do
  let(:user) { FactoryBot.create(:user) }

  scenario 'ログインしていなければUserの編集画面に遷移できないこと' do
    visit edit_user_path
    expect(current_path).to eq root_path
    expect(page).to have_selector '.alert.alert-warning'
  end

  scenario 'ログインしていればUserの編集画面に遷移できること' do
    sign_in user

    visit edit_user_path

    aggregate_failures do
      expect(page).to have_field 'user[name]'
      expect(page).to have_field 'user[email]'
      expect(page).to have_field 'user[sex]'
    end
  end

  scenario 'Userの編集画面で、ユーザー情報の編集ができること' do
    sign_in user

    visit edit_user_path

    fill_in :'名前', with: '変更後の名前'
    fill_in :'Email', with: 'changed@example.com'
    choose 'user_sex_female'
    click_button '更新'

    expect(current_path).to eq root_path
    expect(page).to have_selector '.alert.alert-success'

    user.reload
    aggregate_failures do
      expect(user.name).to eq '変更後の名前'
      expect(user.email).to eq 'changed@example.com'
      expect(user.sex).to eq 'female'
    end
  end
end
