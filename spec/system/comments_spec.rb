# coding: utf-8
require 'rails_helper'

RSpec.describe 'Comment管理', type: :system do
  let(:blog) { FactoryBot.create(:blog) }
  let(:entry) { FactoryBot.create(:entry, blog: blog) }

  scenario 'Commentの新規作成時にbodyを入力しなかった場合にエラーが表示されること' do
    visit blog_entry_path(blog, entry)

    expect {
      click_button '登録'
    }.to_not change(Comment, :count)
    expect(page).to have_content "Bodyを入力してください"
  end

  scenario 'Commentの新規作成時にbodyを入力した場合は未承認状態でデータが保存されること' do
    visit blog_entry_path(blog, entry)

    fill_in :'内容', with: "新しいコメント"
    expect {
      click_button '登録'
    }.to change(Comment, :count).by(1)
    aggregate_failures do
      expect(current_path).to eq blog_entry_path(blog, entry)
      expect(page).to have_content 'Comment was successfully created.'
      expect(page).to_not have_content '新しいコメント'
      expect(page).to have_content '(承認待ち)'
    end
  end

  scenario 'Entryの閲覧画面に関連するCommentの一覧が表示され、承認済みのCommentのみ内容が表示されること' do
    FactoryBot.create(:comment, body: '承認済みコメント', status: 'approved', entry: entry)
    FactoryBot.create(:comment, body: '未承認コメント', status: nil, entry: entry)

    visit blog_entry_path(blog, entry)

    aggregate_failures do
      expect(page).to have_content '承認済みコメント'
      expect(page).to_not have_content '未承認コメント'
      expect(page).to have_content '(承認待ち)'
    end
  end

  scenario 'Entryの閲覧画面で未承認状態のCommentを承認できること' do
    FactoryBot.create(:comment, body: '承認済みコメント', status: 'approved', entry: entry)
    comment = FactoryBot.create(:comment, body: '目的のコメント', status: nil, entry: entry)

    visit blog_entry_path(blog, entry)

    expect(page).to_not have_content '目的のコメント'
    expect(page).to have_content '(承認待ち)'

    click_link 'Approve'

    aggregate_failures do
      expect(current_path).to eq blog_entry_path(blog, entry)
      expect(page).to have_content 'Comment was successfully approved.'
      expect(page).to have_content '目的のコメント'
      expect(page).to_not have_content '(承認待ち)'
    end
  end

  scenario 'Entryの閲覧画面からCommentを削除できること' do
    FactoryBot.create(:comment, body: '承認済みコメント', status: 'approved', entry: entry)
    comment = FactoryBot.create(:comment, body: '目的のコメント', status: nil, entry: entry)

    visit blog_entry_path(blog, entry)

    expect(page).to have_content '(承認待ち)'

    expect {
      within "#comment-row-#{comment.id}" do
        page.accept_confirm 'Are you sure?' do
          click_link 'Destroy'
        end
        expect(current_path).to eq blog_entry_path(blog, entry)
      end
    }.to change(Comment, :count).by(-1)

    aggregate_failures do
      expect(page).to have_content "Comment was successfully destroyed."
      expect(page).to_not have_content '(承認待ち)'
      expect(page).to_not have_content '目的のコメント'
    end
  end
end
