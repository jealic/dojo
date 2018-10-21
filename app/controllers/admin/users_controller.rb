class Admin::UsersController < Admin::BaseController

  def index
    @users = User.page(params[:page]).per(10)
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    if @user.save
      flash[:notice] = "#{@user.name}'s authority has been updated."
    else
      flash[:alert] = @user.errors.full_messages.to_sentence
    end
    redirect_to admin_users_path
  end

  private

  def user_params
    params.require(:user).permit(:role)
  end
end
