module UsersHelper
  def request_friend(user)
    unless @user.friend?(user)
      render partial: "shared/user_item", locals: { user: user }
    end
  end

  # user_info 若顯示按鈕 => return true
  def user_button?(user)
    return true if user == current_user || !current_user.inverse_request_friend?(user)
  end
end
