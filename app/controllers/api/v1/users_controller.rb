class Api::V1::UsersController < ApplicationController

  before_action :set_user, except: [:current_user_data, :following_posts, :following, :followers, :show_by_username]

  def current_user_data
    follower_count = current_user.followers.length
    following_count = current_user.following.length
    render json: {id: current_user.id, name: current_user.name, followers: follower_count, following: following_count}
  end

  def following
    array_to_return = current_user.following.map do |follow|
      {user_id: follow.id, name: follow.name, followers: follow.followers.length, following: follow.following.length}
    end
    # byebug
    render json: array_to_return
  end

  def followers
    array_to_return = current_user.followers.map do |follow|
      {user_id: follow.id, name: follow.name, followers: follow.followers.length, following: follow.following.length}
    end
    render json: array_to_return
  end

  def show
    follower_count = @user.followers.length
    following_count = @user.following.length
    render json: {id: @user.id, name: @user.name, followers: follower_count, following: following_count}
  end

  def show_by_username
    # byebug
    user = User.find_by(name: params[:username])
    follower_count = user.followers.length
    following_count = user.following.length
    render json: {id: user.id, name: user.name, followers: follower_count, following: following_count}
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
    posts = @user.posts.reverse
    post_data = posts.each_with_object([]) do |post, new_array|
      new_array << {id: post.id, content: post.content, created_at: post.created_at, user: post.user.name, likes: post.likes.length, user_id: @user.id}
    end.sort!{ |x, y| x[:id] <=> y[:id] }.reverse
    render json: post_data
  end

  def following_posts
    posts = current_user.following.map do |user|
      user.posts.map do |post|
        post
      end
    end.flatten.sort!{ |x, y| x[:id] <=> y[:id] }.reverse
    posts = posts.map do |post|
      {id: post.id, content: post.content, created_at: post.created_at, user: post.user.name, likes: post.likes.length, user_id: post.user.id}
    end
    render json: posts
  end

  def follow
    if current_user.id == @user.id
      render json: {error: "wow, trying to follow yourself? that's pathetic, even for this website..."}, status: :unauthorized
    elsif !current_user.following?(@user)
      current_user.follow(@user)
      render json: {relationship_made: true, name: @user.name, user_id: @user.id}, status: :ok
    else
      current_user.unfollow(@user)
      render json: {relationship_made: false, name: @user.name, user_id: @user.id}, status: :ok
    end
  end

  def is_following?
    status = current_user.following?(@user)
    render json: {relationship: status}, status: :ok
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

end
