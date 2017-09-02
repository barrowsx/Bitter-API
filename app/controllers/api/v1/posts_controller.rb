class Api::V1::PostsController < ApplicationController
  # skip_before_action :authenticate

  def index
    @posts = Post.all
    post_data = @posts.each_with_object([]) do |post, new_array|
      new_array << {id: post.id, content: post.content, created_at: post.created_at, user: post.user.name}
    end
    render json: post_data
  end
end
