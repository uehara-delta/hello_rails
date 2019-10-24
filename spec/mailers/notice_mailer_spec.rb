# coding: utf-8
require "rails_helper"

RSpec.describe NoticeMailer, type: :mailer do
  describe "confirm_comment_mail" do
    let(:user) { FactoryBot.create(:user) }
    let(:blog) { FactoryBot.create(:blog, user: user) }
    let(:entry) { FactoryBot.create(:entry, blog: blog) }
    let(:comment) { FactoryBot.create(:comment, entry: entry) }
    let(:mail) { NoticeMailer.with(comment: comment).confirm_comment_mail }

    it "コメント通知メールを管理者に送信すること" do
      expect(mail.to).to eq [ user.email ]
    end

    it "サポート用のメールアドレスから送信すること" do
      expect(mail.from).to eq ["noreply@example.com"]
    end

    it "正しい件名で送信すること" do
      expect(mail.subject).to eq "新しいコメントが投稿されました"
    end

    it "メールは multipart形式であること" do
      expect(mail.parts.length).to eq 2
    end

    it "TEXT形式の本文にブログのタイトルが含まれていること" do
      expect(mail.text_part.body.encoded).to match "Blog: #{blog.title}"
    end

    it "TEXT形式の本文にエントリのタイトルが含まれていること" do
      expect(mail.text_part.body.encoded).to match "Entry: #{entry.title}"
    end

    it "TEXT形式の本文にコメントの内容が含まれていること" do
      expect(mail.text_part.body.encoded).to match "Comment: #{comment.body}"
    end

    it "TEXT形式の本文にコメントの投稿者が含まれていること" do
      expect(mail.text_part.body.encoded).to match "Posted by: #{comment.user.name} / #{comment.user.email}"
    end

    it "TEXT形式の本文にエントリの閲覧画面へのURLが含まれていること" do
      expect(mail.text_part.body.encoded).to match "URL: http://localhost:3000/blogs/#{blog.id}/entries/#{entry.id}"
    end

    it "HTMLT形式の本文にブログのタイトルが含まれていること" do
      expect(mail.html_part.body.encoded).to match "Blog: #{blog.title}"
    end

    it "HTML形式の本文にエントリのタイトルが含まれていること" do
      expect(mail.html_part.body.encoded).to match "Entry: #{entry.title}"
    end

    it "HTML形式の本文にコメントの内容が含まれていること" do
      expect(mail.html_part.body.encoded).to match "Comment: #{comment.body}"
    end

    it "HTML形式の本文にコメントの投稿者が含まれていること" do
      expect(mail.html_part.body.encoded).to match "Posted by: #{comment.user.name} / #{comment.user.email}"
    end

    it "HTML形式の本文にエントリの閲覧画面へのリンクが含まれていること" do
      expect(mail.html_part.body.encoded).to match "<a href=\"http://localhost:3000/blogs/#{blog.id}/entries/#{entry.id}\""
    end
  end
end
