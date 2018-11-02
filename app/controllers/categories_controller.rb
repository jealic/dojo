class CategoriesController < ApplicationController
  
  def show
    @categories = Category.all
    @category = Category.find(params[:id])
    @q = @category.posts.where(draft: false).ransack(params[:q])
    @posts = @q.result.page(params[:page]).per(20)
  end
end
