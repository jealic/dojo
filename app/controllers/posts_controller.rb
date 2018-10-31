class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @posts = Post.where(draft: false).page(params[:page]).per(20)
    @categories = Category.all
  end

  def new
    @post = Post.new
    @categories = Category.all
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save && params[:commit] == 'Publish'
      @post.draft = false
      @post.save
      flash[:notice] = "Successfully published."
      redirect_to user_path(current_user)
    elsif @post.save
      redirect_to show_draft_user_path(current_user)
    else
      flash[:alert] = @post.errors.full_messages.to_sentence if @post.errors.any?
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
    if @post.draft == false
      @reply = Reply.new
    end
    @replies = @post.replies.page(params[:page]).per(20)
    # count views
    @post.count_views
  end

  def edit
    @post = Post.find(params[:id])
    if @post.user = current_user
      @categories = Category.all
    else
      flash[:alert] = 'You have no access!'
      redirect_back fallback_location: root_path
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      if @post.draft == true && params[:commit] == 'Publish'
        @post.draft = false
        @post.save
        flash[:notice] = "\"#{@post.title}\" is successfully published."
      else
        flash[:notice] = "\"#{@post.title}\" has been updated."
      end
      redirect_to post_path(@post)
    else
      flash[:alert] = @post.errors.full_messages.to_sentence if @post.errors.any?
      render :edit
    end
  end

  def feeds
    @posts = Post.where(draft: false)
    @users = User.all
    @categories = Category.all
    @replies = Reply.all

    @popular_posts = @posts.order("posts.replies_count DESC").limit(10)
    @popular_users = @users.order("users.replies_count DESC").limit(10)
  end

  def collect
    @post = Post.find(params[:id])
    @post.collects.create!(user: current_user)
    # redirect_back fallback_location: root_path
  end

  def uncollect
    @post = Post.find(params[:id])
    collects = Collect.where(post: @post, user: current_user)
    collects.destroy_all
    # redirect_back fallback_location: root_path

    respond_to do |format|
      format.html { redirect_back fallback_location: root_path }
      format.js
    end
  end
  
  private

  def post_params
    params.require(:post).permit(:title, :content, :image, :draft, :privacy, :category_ids => [])
  end
end
