# coding: utf-8
require 'rails_helper'

RSpec.describe 'レイアウト', type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:user_with_avatar) { FactoryBot.create(:user_with_avatar) }

  scenario 'ログインしていなければ Signin リンクが表示されていること' do
    visit root_path

    expect(page).to have_link 'Signin', href: '/users/auth/google_oauth2'
  end

  scenario 'ログインしていれば、Accountドロップダウンメニューが表示されること' do
    sign_in user

    visit root_path

    save_screenshot "root_with_login_#{Time.zone.now}.png"
    aggregate_failures do
      expect(page).to have_link 'Account'
    end

    click_link 'Account'

    aggregate_failures do
      expect(page).to have_link('Log out', href: '/sign_out')
      expect(page).to have_link(href: '/user/edit')
      expect(page).to have_content user.name
      expect(page).not_to have_select("img[alt='avatar']")
    end
  end

end
