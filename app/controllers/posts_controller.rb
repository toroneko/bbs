class PostsController < ApplicationController
  def index
    @pots = Post.all
  end

  def new
    @posts = Post.new
  end
end
