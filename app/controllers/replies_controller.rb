class RepliesController < ApplicationController
  before_action :set_post
  def create
    if @post.draft == true
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

end
