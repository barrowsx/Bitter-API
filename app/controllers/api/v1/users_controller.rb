class Api::V1::UsersController < ApplicationController

  before_action :set_user, except: [:current_user_data, :following_posts]

  def current_user_data
    follower_count = current_user.followers.length
    following_count = current_user.following.length
    render json: {id: current_user.id, name: current_user.name, followers: follower_count, following: following_count}
  end

  def following

  end

  def followers

  end

  def show
    follower_count = @user.followers.length
    following_count = @user.following.length
    render json: {id: @user.id, name: @user.name, followers: follower_count, following: following_count}
  end

  def update
    render json: {message: 't e s t'}
  end

  def destroy
    if @user.destroy
      render json: {message: 'user #{@user.name} deleted'}, status: :ok
    else
      render json: {message: "Couldn't destroy user  ¯\\_(ツ)_/¯"}, status: 500
    end
  end

  def posts
    render json: @user.posts
  end

  def following_posts
    posts = current_user.following.map do |user|
      user.posts.map do |post|
        post
      end
    end.flatten
    posts = posts.map do |post|
      {id: post.id, content: post.content, created_at: post.created_at, user: post.user.name}
    end
    render json: posts
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

end
