class Api::V1::PostsController < ApiController
  before_action :authenticate_user!, except: :index
  before_action :set_post, only: [:show, :update, :destroy]

  def index
    @categories = Category.all
    if current_user
      if @category = Category.find_by(id: params[:category_id])
        @posts = @category.posts.access_posts(current_user).published
      else
        @posts = Post.access_posts(current_user).published
      end
    else
      if @category = Category.find_by(id: params[:category_id])
        @posts = @category.posts.published.where(privacy: "all_user")
      else
        @posts = Post.published.where(privacy: "all_user")
      end
    end

    render json: {
      data: @posts.map do |post|
        {
          title: post.title,
          content: post.content,
          image: post.image,
          categories: post.categories.map do |c|
            {
              name: c.name,
            }
          end
        }
      end
    }
  end

  def show
    if @post.be_viewed_by?(current_user)
      @reply = Reply.new
      @replies = @post.replies.order("updated_at DESC").page(params[:page]).per(20)
      @post.count_views
      @post.save
    else
      flash[:alert] = 'The post is not open to you.'
      redirect_back fallback_location: root_path
    end
    if !@post
      render json: {
        message: "can't find the post!",
        status: 400
      }
    else
      render json: {
        title: @post.title,
        content: @post.content,
        image: @post.image,
        categories: @post.categories.map do |c|
          {
            name: c.name,
          }
        end,
        replies: @post.replies.map do |reply|
          {
            user: reply.user.name,
            comment: reply.comment,
          }
        end
      }
    end
    
  end


  private

  def set_post
    @post = Post.find_by(id: params[:id])
  end

  def post_params
    params.permit(:title, :content, :image, :draft, :privacy, category_ids: [])
  end

end
