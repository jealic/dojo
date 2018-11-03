module ApplicationHelper
  # 星號「*」的使用: https://ithelp.ithome.com.tw/articles/10160672
  def action?(*action)
    action.include?(params[:action])
    # 對應 routes/controller 的自訂 action
  end

  def invite_btn(user) 
  # 用 invite column 來判斷 user 的四種友誼狀態, 這四種狀態已在 user model 設定好
  if user == current_user
    content_tag(:span, 'Me', class: 'badge badge-info')
  elsif current_user.friend_state(user).blank?
    button_to '+ Friend', invite_friend_user_path(user), class: "btn btn-outline-success"
  elsif current_user.friend_state(user) == 'accept' # 沒有做刪除 friend 的選項
    content_tag(:span, 'My Friend', class: 'btn btn-success')
  else
    content_tag(:span, 'Waiting...'), class: 'btn btn-outline-secondary disabled')
  end
end
