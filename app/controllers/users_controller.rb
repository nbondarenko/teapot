##
#This class shows actions to do with users in aplication
class UsersController < ApplicationController
  ##
  #Creates new user from permited query params and creates some kind of user session in app
  #by initializing unique token for user.
  #
  #In case of errors renders it in json and returnes 400 HTTP status
  #In case of successful creation returns user information in json format with 200 HTTP status

  def create
    @user = User.new(email: user_params[:email], password: user_params[:password])
    @user.token = set_unique_token(@user)
    if @user.save
      cookies[:token] = { value: @user.token, expires: 1.year.from_now }
      render json: @user, status: 201
    else
      render json: { error: @user.errors.full_messages.join(', ') }, status: 400
    end
  end

  ##
  #Creates some kind of user session in app for user which params are proceeded to method
  #by initializing unique token for user.
  #Creates browser cookie and stores token here.
  #
  #In case of errors renders it in json and returnes 400 HTTP status
  #In case of successful creation returns user information in json format with 200 HTTP status

  def sign_in
    if user_params[:email].blank? || user_params[:password].blank?
      return render json: { error: 'All fields must be filled' }, status: 400
    end
    @user = User.where(email: user_params[:email],  password: user_params[:password]).first
    if @user.present?
      @user.token = set_unique_token(@user)
      if @user.save
        cookies[:token] = { value: @user.token, expires: 1.year.from_now }
        render json: @user, status: 200
      else
        render json: { error: 'Error has occured while signing in'}, status: 400
      end
    else
      render json: { error: 'No such user' }, status: 400
    end
  end

  ##
  #Searches for existing user session by checking browser cookies.
  #
  #In case of successful search returns json with flag and user information and 200 HTTP status
  #In case of failure returnes json with flag withoutuser and 200 HTTP status

  def sign_in_primary
    if(cookies[:token] && User.where(token: cookies[:token]).first.present?)
      @user = User.where(token: cookies[:token]).first
      render json: { user: @user,  hadAuth: true }, status: 200
    else
      render json: { hadAuth: false }, status: 200
    end
  end

  ##
  #Destroys current user session and deletes browser cookie.

  def destroy
    unless(cookies[:token] && User.where(token: cookies[:token]).first.present?)
      return render json: { error: "Authorization error" }, status: 401
    end
    user = User.find(params[:id])
    if user
      cookies.delete :token
      user.update_column(:token, nil)
      render  status: 200
    else
      render status: 400
    end
  end

  private

  def user_params
    params.require(:user).permit(:id, :email, :password, :primary)
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
