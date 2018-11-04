class Api::V1::PostsController < ApiController
  before_action :authenticate_user!, except: :index
  before_action :set_post, only: [:show, :update, :destroy]

  def index
    @categories = Category.all
    if current_user

      if params[:category_id]
        render json: {
          category:
          {
            name: @category.name
          },

          posts_data: @category.posts.map do |post|
            {
              title: post.title,
              content: post.content,
              image: post.image,
              privacy: post.privacy,
              draft: post.draft,
            }
          end
        }
      else
        @posts = Post.all
        render json: {
          posts_data: @posts.map do |post|
            {
              title: post.title,
              content: post.content,
              image: post.image,
              privacy: post.privacy,
              draft: post.draft,
            }
          end
        }
      end

    end
  end

  def show
    
    if !@post
      render json: {
        message: "can't find the post!",
        status: 400
      }
    else
      @post.count_views
      @replies = @post.replies
      render json: {
        title: @post.title,
        content: @post.content,
        image: @post.image,
        draft: @post.draft,
        privacy: @post.privacy,

        categories_data: @post.categories.map do |c|
          {
            name: c.name,
          }
        end,
        replies_data: @post.replies.map do |reply|
          {
            user: reply.user.name,
            comment: reply.comment,
          }
        end,
      }
    end
  end

  def create
    @post = Post.new(post_params)

    if @post.save
      render json: {
        message: "A Post has been created.",
        result: @post
      }
    else
      render json: {
        errors: @post.erros
      }
    end
  end

  def update
    if @post.update(post_params)
      render json: {
        message: "Post updated successfully!",
        result: @post
      }
    else
      render json: {
        errors: @post.errors
      }
    end
  end

   def destroy
    @post.destroy
    render json: {
      message: "Post destroy successfully!"
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
