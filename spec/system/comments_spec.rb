# coding: utf-8
require 'rails_helper'

RSpec.describe 'Comment管理', type: :system do
  context "ユーザーがログインしている場合" do
    let(:user) { FactoryBot.create(:user) }
    let(:blog) { FactoryBot.create(:blog, user: user) }
    let(:entry) { FactoryBot.create(:entry, blog: blog) }

    scenario 'Commentの新規作成時にbodyを入力しなかった場合にエラーが表示されること' do
      sign_in user

      visit blog_entry_path(blog, entry)

      expect {
        click_button '登録'
      }.to_not change(Comment, :count)
      expect(page).to have_content "Bodyを入力してください"
    end

    scenario 'Commentの新規作成時にbodyを入力した場合は未承認状態でデータが保存されること' do
      ActiveJob::Base.queue_adapter.perform_enqueued_at_jobs = true
      ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true

      sign_in user

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
      mail = ActionMailer::Base.deliveries.last

      aggregate_failures do
        expect(mail.to).to eq [ user.email ]
        expect(mail.text_part.body.encoded).to match "Blog: #{blog.title}"
        expect(mail.html_part.body.encoded).to match "Blog: #{blog.title}"
      end
    end

    scenario 'Entryの閲覧画面に関連するCommentの一覧が表示され、承認済みのCommentのみ内容が表示されること' do
      FactoryBot.create(:comment, body: '承認済みコメント', status: 'approved', entry: entry)
      FactoryBot.create(:comment, body: '未承認コメント', status: nil, entry: entry)

      sign_in user

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

      sign_in user

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

      sign_in user

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

  context "ユーザーがログインしていない場合" do
    let(:blog) { FactoryBot.create(:blog) }
    let(:entry) { FactoryBot.create(:entry, blog: blog) }

    scenario 'Entryの閲覧画面にCommentの削除リンクと承認リンクが表示されないこと(Commentは未承認)' do
      comment = FactoryBot.create(:comment, entry: entry)

      visit blog_entry_path(blog, entry)

      aggregate_failures do
        expect(page).to have_content '(承認待ち)'
        expect(page).not_to have_link 'Destroy'
        expect(page).not_to have_link 'Approve'
      end
    end

    scenario 'Entryの閲覧画面にCommentの削除リンクが表示されないこと(Commentは承認済み)' do
      comment = FactoryBot.create(:comment, status: 'approved', entry: entry)

      visit blog_entry_path(blog, entry)

      aggregate_failures do
        expect(page).to have_content comment.body
        expect(page).not_to have_link 'Destroy'
      end
    end

    scenario 'Entryの閲覧画面にCommentの作成用フォームが表示されないこと' do
      visit blog_entry_path(blog, entry)

      aggregate_failures do
        expect(page).not_to have_selector "form#new_comment"
        expect(page).not_to have_field "comment[body]"
      end
    end
  end

  context "ログインユーザーとは異なるユーザーが作成したブログの場合" do
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:user) }
    let(:others_blog) { FactoryBot.create(:blog, user: other_user, title: '他人のブログ') }
    let(:entry) { FactoryBot.create(:entry, blog: others_blog) }

    scenario 'Entryの閲覧画面からCommentの新規作成ができること' do
      ActiveJob::Base.queue_adapter.perform_enqueued_at_jobs = true
      ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true

      sign_in user

      visit blog_entry_path(others_blog, entry)

      fill_in :'内容', with: '新しいコメント'
      expect {
        click_button '登録'
      }.to change(Comment, :count).by(1)
      aggregate_failures do
        expect(current_path).to eq blog_entry_path(others_blog, entry)
        expect(page).to have_content 'Comment was successfully created.'
        expect(page).to_not have_content '新しいコメント'
        expect(page).to have_content '(承認待ち)'
      end
      mail = ActionMailer::Base.deliveries.last

      aggregate_failures do
        expect(mail.to).to eq [ other_user.email ]
        expect(mail.text_part.body.encoded).to match "Blog: #{others_blog.title}"
        expect(mail.html_part.body.encoded).to match "Blog: #{others_blog.title}"
      end
    end

    scenario 'Entryの閲覧画面にCommentの削除リンクと承認リンクが表示されないこと(Commentは未承認)' do
      comment = FactoryBot.create(:comment, entry: entry, status: nil)

      sign_in user

      visit blog_entry_path(others_blog, entry)

      aggregate_failures do
        expect(page).to have_content '(承認待ち)'
        expect(page).not_to have_link 'Destroy'
        expect(page).not_to have_link 'Approve'
      end
    end

    scenario 'Entryの閲覧画面にCommentの削除リンクが表示されないこと(Commentは承認済み)' do
      comment = FactoryBot.create(:comment, entry: entry, status: 'approved')

      visit blog_entry_path(others_blog, entry)

      aggregate_failures do
        expect(page).to have_content comment.body
        expect(page).not_to have_link 'Destroy'
      end
    end
  end
end
