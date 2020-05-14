class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :followers, :notices_check]
  before_action :correct_user, only: [:edit, :update, :notices_check]

  def show
    @user = User.find(params[:id])
    @articles = Article.user_have_all(params[:id], params[:page])
    @microposts = Micropost.user_have_all(params[:id], params[:page])
    @micropost_like = Like.micropost_like(current_user) if logged_in?
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

  def notices_check
    nonchecked_notices = Notification.where(received_user_id: params[:id], checked: false)
    nonchecked_notices.each do |notice|
      notice.update(checked: true)
    end
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js
    end
  end

private

  def user_params
    params.require(:user).permit(:name, :unique_name, :email, :password, :password_confirmation, :icon)
  end


  def correct_user
    @user = User.find(params[:id])
    unless current_user == @user
      redirect_to root_url
      flash[:danger] = '許可されていないリクエストです'
    end
  end

end
