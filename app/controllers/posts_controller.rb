class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  before_action :set_post, only: [:show, :edit, :update, :collect, :uncollect, :destroy]

  def index
    @q = Post.where(draft: false).ransack(params[:q])
    @posts = @q.result.order(id: :desc).page(params[:page]).per(20)
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
    
    if @post.draft == false
      @reply = Reply.new
    end
    @replies = @post.replies.order("updated_at DESC").page(params[:page]).per(20)
    # count views
    @post.count_views
  end

  def edit
    if @post.user = current_user
      if current_user.admin?
        flash[:alert] = 'Admin can only delete the post.'
        redirect_back fallback_location: root_path
      end
      @categories = Category.all
    else
      flash[:alert] = 'You have no access to this action!'
      redirect_back fallback_location: root_path
    end
  end

  def update
    
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
    
    @post.collects.create!(user: current_user)
    # redirect_back fallback_location: root_path
  end

  def uncollect
    
    collects = Collect.where(post: @post, user: current_user)
    collects.destroy_all
    # redirect_back fallback_location: root_path

    respond_to do |format|
      format.html { redirect_back fallback_location: root_path }
      format.js
    end
  end

  def destroy
    
    if @post.user = current_user || current_user.admin?
      @post.destroy
      flash[:notice] = "Successfully deleted post \"#{@post.title}\"."
      redirect_to root_path
    else
      flash[:alert] = "Have no authority to this deleting action!"
      redirect_back fallback_location: root_path
    end
    
  end
  
  private

  def post_params
    params.require(:post).permit(:title, :content, :image, :draft, :privacy, :category_ids => [])
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
