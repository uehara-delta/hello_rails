class NoticeMailerPreview < ActionMailer::Preview
  def confirm_comment_mail
    NoticeMailer.with(comment: Comment.first).confirm_comment_mail
  end
end
