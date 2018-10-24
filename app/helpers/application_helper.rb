module ApplicationHelper
  # 星號「*」的使用: https://ithelp.ithome.com.tw/articles/10160672
  def action?(*action)
    action.include?(params[:action])
  end
end
