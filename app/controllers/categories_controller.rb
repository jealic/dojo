class CategoriesController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    @categories = Category.all
    if current_user
      if @category = Category.find(params[:id])
        @q = @category.posts.access_posts(current_user).published.ransack(params[:q])
      else
        @q = Post.access_posts(current_user).published.ransack(params[:q])
      end
    else
      if @category = Category.find(params[:id])
        @q = @category.posts.published.where(privacy: "all_user").ransack(params[:q])
      else
        @q = Post.published.where(privacy: "all_user").ransack(params[:q])
      end
    end
    @posts = @q.result.page(params[:page]).per(20)
  end
end
