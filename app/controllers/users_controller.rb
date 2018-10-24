class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.where(draft: false).order("posts.created_at DESC")
  end

  def show_draft
    @user = User.find(params[:id])
    if @user == current_user
      @drafts = @user.posts.where(draft: true).order("posts.created_at DESC")
      render :show
    else
      flash[:alert] = "You have no access to other people's drafts."
      redirect_back fallback_location: root_path
    end
  end

  def show_reply
    @user = User.find(params[:id])
    @replies = @user.replies.order("replies.created_at DESC")
    render :show
  end

  private

end
