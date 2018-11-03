class UsersController < ApplicationController
  
  before_action :set_user

  def show
    
    @posts = @user.posts.where(draft: false).page(params[:page]).per(10).order("posts.created_at DESC")
  end

  def edit
    
    unless @user == current_user
      flash[:alert] = "You have no access editing other people's profile."
      redirect_back fallback_location: root_path
    end    
  end

  def update
    
    if @user.update(user_params)
      flash[:notice] = "Updated successfully."
      redirect_back fallback_location: root_path
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence if @user.errors.any?
      render :edit
    end
  end

  def show_draft
    
    if @user == current_user
      @drafts = @user.posts.where(draft: true).order("posts.created_at DESC").page(params[:page]).per(10)
      render :show
    else
      flash[:alert] = "You have no access to other people's drafts."
      redirect_back fallback_location: root_path
    end
  end

  def show_reply
    
    @replies = @user.replies.order("replies.created_at DESC").page(params[:page]).per(10)

    render :show
  end

  def show_collect
    
    if @user == current_user
      @collects = @user.collected_posts.order("collects.created_at DESC").page(params[:page]).per(10)
      render :show    
    else
      @collects = @user.collected_posts.order("collects.created_at DESC").page(params[:page]).per(10)
      render :show
    end
  end

  def show_friend
    if @user == current_user
      @waitings = @user.waiting_accept_friends
      @requests = @user.waiting_response_friends
      @friends = (@user.friends.all + @user.inverse_friends.all.uniq)

      render :show
    else
      flash[:alert] = "Have no access to others' friend list."
      redirect_back fallback_location: root_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :intro, :avatar)
  end

  def set_user
    @user = User.find(params[:id])
  end

end
