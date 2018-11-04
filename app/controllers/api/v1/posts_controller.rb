class Api::V1::PostsController < ApiController
  before_action :authenticate_user!, except: :index

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
          category_ids: post.categories.ids
        }
      end
    }
  end



  private

  def set_post
    @post = Post.find_by(id: params[:id])
  end

  def post_params
    params.permit(:title, :content, :image, :draft, :privacy, category_ids: [])
  end

end
