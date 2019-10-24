# coding: utf-8
class NoticeMailer < ApplicationMailer
  def confirm_comment_mail
    @comment = params[:comment]
    @entry = @comment.entry
    @blog = @entry.blog
    mail to: @blog.user.email, subject: "新しいコメントが投稿されました"
  end
end
