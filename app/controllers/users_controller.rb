class UsersController < ApplicationController
  skip_before_action :authenticate

  def create
    new_user = User.new(user_params)
    taken_names = User.all.map do |user|
      user.name
    end
    if !taken_names.include?(new_user.name)
      new_user.save
      render json: {message: "User #{new_user.name} created."}, status: :ok
    else
      render json: {message: "Couldn't create new user #{new_user.name}"}, status: :unauthorized
    end
  end

  def test
    render json: {message: 'you did it boyo!!!!!!!!!!'}
  end

  private

  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation)
  end

end
