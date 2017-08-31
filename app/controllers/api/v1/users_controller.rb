class Api::V1::UsersController < ApplicationController

  before_action :set_user

  def show
    render json: {message: "#{@user.name}"}
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

  private

  def set_user
    @user = User.find(params[:id])
  end

end
