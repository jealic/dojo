class Admin::CategoriesController < Admin::BaseController
  def index
    @categories = Category.all 
    if params[:id]
      @category = Category.find(params[:id])
    else
      @category = Category.new
    end
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = "Category #{@category.name.capitalize} has been created."
      redirect_to admin_categories_path
    else
      @categories = Category.all
      render :index
    end
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      redirect_to admin_categories_path
      flash[:notice] = "Category #{@category.name.capitalize} has been updated."
    else
      @categories = Category.all
      render :index
    end
  end

  def destroy
    @category = Category.find(params[:id])
    if @category.destroy
      flash.now[:alert] = "Category #{@category.name.capitalize} has been deleted."
    else
      flash[:alert] = "Category #{@category.name.capitalize} belongs to a post and can't be deleted."  
    end
    
    redirect_to admin_categories_path
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
