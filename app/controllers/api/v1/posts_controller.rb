require "google/cloud/language"

class Api::V1::PostsController < ApplicationController
  # skip_before_action :authenticate

  authorization = Google::Auth.get_application_default('https://www.googleapis.com/auth/cloud-platform')

  def index
    @posts = Post.all.reverse
    post_data = @posts.each_with_object([]) do |post, new_array|
      new_array << {id: post.id, content: post.content, created_at: post.created_at, user: post.user.name, likes: post.likes.length, user_id: post.user.id}
    end.sort!{ |x, y| x[:id] <=> y[:id] }.reverse
    render json: post_data
  end

  def create
    language = Google::Cloud::Language.new project: ENV['BITTER_PROJECT_ID']
    document = language.document params[:user][:content]
    sentiment = document.sentiment
    if sentiment.score < 0
      post = Post.new(user: current_user, content: params[:user][:content])
      if post.save
        render json: post
      else
        render json: {error: "couldn't post for some reason"}, status: :unauthorized
      end
    else
      render json: {error: "you need to be more negative than that", sentiment_score: sentiment.score}, status: :unauthorized
    end
  end

  def like_post
    @post = Post.find(params[:id])
    current_user.like(@post)
    post_likes = Like.where(post_id: @post.id).length
    render json: {id: @post.id, content: @post.content, created_at: @post.created_at, user: @post.user.name, likes: post_likes}
  end

  def load_post_likes
    @post = Post.find(params[:id])
    post_likes = Like.where(post_id: @post.id).length
    render json: {id: @post.id, likes: post_likes}
  end
end
