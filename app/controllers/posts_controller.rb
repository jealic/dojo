class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @posts = Post.page(params[:page]).per(10)
    @categories = Category.all
  end

  def new
    @post = Post.new
    @categories = Category.all
  end
  
end
