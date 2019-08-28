# coding: utf-8
# Preview all emails at http://localhost:3000/rails/mailers/notice_mailer
class NoticeMailerPreview < ActionMailer::Preview
  def confirm_comment_mail
    NoticeMailer.with(comment: FactoryBot.create(:comment)).confirm_comment_mail
  end
end
