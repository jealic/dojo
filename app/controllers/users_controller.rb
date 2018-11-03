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

  def invite_friend
    if @user == current_user
      flash[:alert] = "Can't friend myself."
      redirect_back fallback_location: root_path
      # 防止一切平台外部的操作
    else
      @friendship = Friendship.create(user: current_user, friend: @user)
      # 指定 pass in tables 的資料
      if @friendship.save
        flash[:notice] = "Sent invitation"
      else
        flash[:alert] = friendship.errors.full_messages.to_sentence if friendship.errors.any?
      end
    end
  end

  def accept_friend
    friendship = Friendship.find_by(user: @user, friend: current_user)
    # 找到被別人邀請的那比資料，也就是 B→A + pending 這筆
    friendship.invite = "accpet" # 改寫 invite column 的 string 值
    if friendship.save
      @accepted_frienders = current_user.frienders.where('friendships.invite = ?', 'pending')
      # 回去找出寄邀請給我的那比資料的 user (使用 inverse_friendships) || 那比資料的 invite 是 pending 值
      flash[:notice] = "Friendship with #{@user.name} is permitted."
    else
      flash[:alert] = friendship.errors.full_messages.to_sentence if friendship.errors.any?
      redirect_back fallback_location: root_path
    end
  end

  def ignore_friend
    friendship = Friendship.find_by(user: @user, friend: current_user)
    friendship.invite = "ignore"
    if friendship.save
      @ignored_frienders = current_user.frienders.where('friendships.invite = ?', 'pending')
      flash[:notice] = "Ignore #{@user.name}'s friendship invitation."
    else
      flash[:alert] = friendsihp.errors.full_messages.to_sentence if friendship.errors.any?
      redirect_back fallback_location: root_path
    end
  end

  def show_friend
    if @user == current_user
      @waiting_ones = current_user.friends.where.not('friendships.invite = ?', 'accept')
      # 我邀請但還沒回覆者
      @friends = current_user.friends.where('friendships.invite = ?', 'accept')
      # ↑ 用上 friendships table, ↓ 用上 inverse_friendships table
      @inviters = current_user.frienders.where('friendships.invite = ?', 'pending')
      
      render :show
    else
      flash[:alert] = '沒有觀看權限'
      redirect_back(fallback_location: root_path)
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
