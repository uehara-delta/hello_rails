# coding: utf-8
class NoticeMailer < ApplicationMailer
  def confirm_comment_mail
    @comment = params[:comment]
    @entry = @comment.entry
    @blog = @entry.blog
    mail to: "admin@example.com", subject: "新しいコメントが投稿されました"
  end
end
