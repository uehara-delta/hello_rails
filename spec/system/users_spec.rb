# coding: utf-8
require 'rails_helper'

RSpec.describe 'User管理', type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:user_with_avatar) { FactoryBot.create(:user_with_avatar) }

  scenario 'ログインしていなければUserの編集画面に遷移できないこと' do
    visit edit_user_path
    expect(current_path).to eq root_path
    expect(page).to have_selector '.alert.alert-warning'
  end

  scenario 'ログインしていればUserの編集画面に遷移できること' do
    user = FactoryBot.create(:user)
    sign_in user

    visit edit_user_path

    aggregate_failures do
      expect(page).to have_field 'user[name]'
      expect(page).to have_field 'user[email]'
      expect(page).to have_field 'user[sex]'
      expect(page).to have_field 'user[avatar]'

      # アバター画像は登録されていないためアバターを削除は表示されない
      expect(page).not_to have_field 'user[remove_avatar]'
    end
  end

  scenario 'Userの編集画面で、ユーザー情報の編集ができること' do
    # 名前、Emailの変更、性別の選択、アバター画像の登録ができること"
    sign_in user
    visit edit_user_path

    fill_in "名前", with: '変更後の名前'
    fill_in "Email", with: 'changed@example.com'
    choose 'user_sex_female'
    attach_file "アバター", "#{Rails.root}/spec/files/sample_avatar.jpg"
    click_button '更新'

    expect(current_path).to eq root_path
    expect(page).to have_selector '.alert.alert-success'

    user.reload
    aggregate_failures do
      expect(user.name).to eq '変更後の名前'
      expect(user.email).to eq 'changed@example.com'
      expect(user.sex).to eq 'female'
      expect(user.avatar?).to be_truthy
    end
  end

  scenario "Userの編集画面で、アバター画像の削除ができること" do
    sign_in user_with_avatar

    visit edit_user_path

    aggregate_failures do
      expect(page).to have_field 'user[remove_avatar]'
    end

    check 'user_remove_avatar'
    click_button '更新'

    expect(current_path).to eq root_path
    expect(page).to have_selector '.alert.alert-success'

    user_with_avatar.reload
    aggregate_failures do
      expect(user_with_avatar.avatar?).not_to be_truthy
    end
  end
end
