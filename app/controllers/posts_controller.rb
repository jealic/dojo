class PostsController < ApplicationController

  def index
    @posts = Post.page(params[:page]).per(10)
    @categories = Category.all
  end
  
end
