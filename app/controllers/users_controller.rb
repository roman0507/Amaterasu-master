class UsersController < ApplicationController
  before_action :signed_in_user,
                only: [:index, :show, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page]).search(params[:search])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = t(:email_check)
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    current_password = params[:user].delete(:current_password)
    if @user.authenticate(current_password) && @user.update(user_params)
      flash[:success] = t(:update_profile)
      redirect_to @user
    else
      @user.errors.add(:current_password, t(:incorrect)) unless @user.authenticate(current_password)
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = t(:delete_user)
    redirect_to users_url
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def following
    @title = t(:following)
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = t(:followers)
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
end
