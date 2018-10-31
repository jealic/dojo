class RepliesController < ApplicationController
  
  before_action :set_post
  before_action :set_reply, only: [:destroy, :edit, :update]

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

  def destroy
    
    if @reply.user == current_user
      @reply.destroy
      flash[:notice] = "Successfully deleted a comment."
    else
      flash[:alert] = "Have no authority to this deleting action."
    end
    redirect_back fallback_location: root_path
  end

  def update
    if @reply.update(reply_params)
      flash[:notice] = "Your comment on \"#{@reply.post.title}\" has been updated."
    else
      flash[:alert] = @reply.errors.full_messages.to_sentence if @reply.errors.any?
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

  def set_reply
    @reply = Reply.find(params[:id])
  end

end
