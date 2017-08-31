class Api::V1::PostsController < ApplicationController
  skip_before_action :authenticate

  def index
    @posts = Post.all[0..19]
    render json: @posts
  end
end
