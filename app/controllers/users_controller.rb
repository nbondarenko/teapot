class UsersController < ApplicationController
  def create
    @user = User.new(email: user_params[:email], password: user_params[:password])
    @user.token = set_unique_token(@user)
    if @user.save
      cookies[:token] = {value: @user.token, expires: 1.year.from_now}
      render json: @user
    else
      render json: { id: 0, errors: @user.errors.full_messages.join(', ') }
    end
  end

  def sign_in
    if !user_params[:primary]
      if user_params[:email].blank? || user_params[:password].blank?
        render json: {id: 0, errors: 'All fields must be filled'}
      end
      @user = User.where(email: user_params[:email],  password: user_params[:password]).first
      if !@user.nil?
        @user.token = set_unique_token(@user)
        if @user.save
          cookies[:token] = {value: @user.token, expires: 1.year.from_now}
          render status: 200, json: @user
        else
          render json: {id: 0, errors: 'Error while singing in'}
        end
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
    cookies.delete :token
    render  status: 200, json: {}
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :primary)
  end
  def set_unique_token(user)
    userToken = ''
    loop do
      userToken = SecureRandom.uuid
      break unless User.exists?(token: userToken)
    end
    userToken
  end

end
