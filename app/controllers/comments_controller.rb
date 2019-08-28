class CommentsController < ApplicationController
  before_action :set_entry
  before_action :set_comment, only: [:approve, :destroy]

  # POST /blogs/1/entries/1/comments
  # POST /blogs/1/entries/1/comments.json
  def create
    @comment = Comment.new(comment_params)
    @comment.status = 'unapproved'
    respond_to do |format|
      if @comment.save
        NoticeMailer.with(comment: @comment).confirm_comment_mail.deliver_later
        format.html { redirect_to [@blog, @entry], notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: [@blog, @entry, @comment] }
      else
        format.html { redirect_to [@blog, @entry], alert: @comment.errors.full_messages.join("\n") }
        format.json { render json: @comment.errors, status: :unprocessable_comment }
      end
    end
  end

  # PUT /blogs/1/entries/1/comments/1/approve
  # PUT /blogs/1/entries/1/comments/1/approve.json
  def approve
    respond_to do |format|
      if @comment.update(status: "approved")
        format.html { redirect_to [@blog, @entry], notice: 'Comment was successfully approved.' }
        format.json { render :show, status: ok, location: [@blog, @entry, @comment] }
      else
        format.html { redirect_to [@blog, @entry], notice: @comment.errors.full_messages.join("\n") }
        format.json { render json: @comment.errors, status: :unprocessable_comment }
      end
    end
  end

  # DELETE /blogs/1/entries/1/comments/1
  # DELETE /blogs/1/entries/1/comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to [@blog, @entry], notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_entry
      @blog = Blog.find(params[:blog_id])
      @entry = Entry.find(params[:entry_id])
    end

    def set_comment
      @comment = Comment.find(params[:id])
      unless @comment.entry_id == @entry.id && @entry.blog_id == @blog.id
        head :not_found
      end
    end

    def comment_params
      params.require(:comment).permit(:body).merge(entry_id: params[:entry_id])
    end

end
