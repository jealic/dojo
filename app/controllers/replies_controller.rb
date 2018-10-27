class RepliesController < ApplicationController
  
  before_action :set_post

  def create
    if @post.draft == false
      @reply = @post.replies.new(reply_params)
      @reply.user = current_user
      if @reply.save
        flash[:notice] = "You've commented in article \"#{@post.title}\". "
      else
        flash[:alert] = @reply.errors.full_messages.to_sentence if @reply.errors.any?
      end
    else
      flash[:alert] = "You cannot leave your comment here!"
    end
    redirect_to post_path(@post)
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def reply_params
    params.require(:reply).permit(:comment)
  end

end
