class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @posts = Post.where(draft: false).page(params[:page]).per(10)
    @categories = Category.all
  end

  def new
    @post = Post.new
    @categories = Category.all
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user

  end

  def show
    @post = Post.find(params[:id])
    @reply = Reply.new
    @replies = @post.replies.all
    # count views
    @post.count_views
  end
  
  private

  def post_params
    params.require(:post).permit(:title, :description, :image, :draft, :privacy, :category_ids => [])
  end
end
