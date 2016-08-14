class UsersController < ApplicationController
  def create
    userToken = SecureRandom.uuid
    @user = User.new(email: user_params[:email], password: user_params[:password], token: userToken)
    if @user.save
      cookies[:token] = userToken
      render json: @user
    else
      render json: { id: 0, errors: @user.errors.full_messages.join(', ') }
    end
  end

  def sign_in
    if !user_params[:primary]
      @user = User.where(email: user_params[:email],  password: user_params[:password]).first
      if !@user.nil?
        cookies[:token] = @user.token
        render json: @user
      else
        render json: { id: 0, errors: 'No such user' }
      end
    else
      if(!cookies[:token] || User.where(token: cookies[:token]).first.nil?)
        render json: { hadAuth: false }
      else
        render json: { hadAuth: true }
      end
    end
  end
  def destroy
    cookies.delete('token');
    render json: {}
  end
  private

  def user_params
    params.require(:user).permit(:email, :password, :primary)
  end
end
