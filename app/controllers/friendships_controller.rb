class FriendshipsController < ApplicationController
  
  before_action :set_user, only: [:accept, :ignore]
  before_action :set_friendship, only: [:accept, :ignore]

  def create
    @user = User.find(params[:friend_id])
    @friendship = current_user.request_friendships.build(friend_id: params[:friend_id])
    if @friendship.save
      if @friendship.save
        flash[:notice] = "You've sent a friend request."
      else 
        flash[:alert] = @friendship.errors.full_messages.to_sentence if @friendship.errors.any?
      end
      redirect_back fallback_location: root_path
    end
  end

  def accept
    

    if @friendship.update(status: true) # accept 被執行後，status 改 true
      flash[:notice] = "You are friends now."
    else
      flash[:alert] = @friendship.errors.full_messages.to_sentence if @friendship.errors.any?
    end
    redirect_back fallback_location: root_path
  end

  def ignore


    if @friendship.destroy
      flash[:alert] = "#{@user.name} isn't your friend anymore."
    else
      flash[:alert] = @friendship.errors.full_messages.to_sentence if @friendship.errors.any?
    end
    redirect_back fallback_location: root_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def set_friendship
    @friendship = current_user.inverse_request_friendships.find_by(user_id: params[:id])
  end

end
