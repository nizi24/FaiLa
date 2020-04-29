class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :followers]
  before_action :correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @articles = Article.where(user_id: params[:id]).order(created_at: :desc).paginate(page: params[:page], per_page: 20)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user
      flash[:success] = 'ユーザー登録が完了しました'
      log_in @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.icon.attach(params[:user][:icon])
    if @user.update(user_params)
      flash[:success] = '更新に成功しました'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followers
    render 'relationships/followers'
  end

private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :icon)
  end


  def correct_user
    @user = User.find(params[:id])
    unless current_user == @user
      redirect_to root_url
      flash[:danger] = '許可されていないリクエストです'
    end
  end

end
