class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.where(draft: false).page(params[:page]).per(10).order("posts.created_at DESC")
  end

  def edit
    @user = User.find(params[:id])
    unless @user == current_user
      flash[:alert] = "You have no access editing other people's profile."
      redirect_back fallback_location: root_path
    end    
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "Updated successfully."
      redirect_back fallback_location: root_path
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence if @user.errors.any?
      render :edit
    end
  end

  def show_draft
    @user = User.find(params[:id])
    if @user == current_user
      @drafts = @user.posts.where(draft: true).order("posts.created_at DESC").page(params[:page]).per(10)
      render :show
    else
      flash[:alert] = "You have no access to other people's drafts."
      redirect_back fallback_location: root_path
    end
  end

  def show_reply
    @user = User.find(params[:id])
    @replies = @user.replies.order("replies.created_at DESC").page(params[:page]).per(10)
    render :show
  end

  def show_collect
    @user = User.find(params[:id])
    if @user == current_user
      @collects = @user.collected_posts.order("collects.created_at DESC").page(params[:page]).per(10)
      render :show    
    else
      @collects = @user.collected_posts.order("collects.created_at DESC").page(params[:page]).per(10)
      render :show
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :intro, :avatar)
  end

end
