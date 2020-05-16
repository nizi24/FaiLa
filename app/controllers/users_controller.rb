class UsersController < ApplicationController
  before_action :logged_in_user, only: [:update, :followers, :notices_check, :setting_form, :setting]
  before_action :correct_user, only: [:update, :notices_check, :setting_form, :setting]

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
      create_settings #ユーザーの設定を構築
      redirect_to @user
      flash[:success] = 'ユーザー登録が完了しました'
      log_in @user
    else
      render 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    @user.icon.attach(params[:user][:icon])
    if @user.update(user_params)
      flash[:success] = '更新に成功しました'
      redirect_to @user
    else
      render 'setting_form'
    end
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followers
    render 'relationships/followers'
  end

  # checkedをすべてtrueにする
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

  def setting_form
    @user = User.find(params[:id])
  end

  def setting
    current_user.setting.update(setting_params)
    flash[:success] = '設定を変更しました'
    redirect_to user_path(current_user)
  end

private

  def user_params
    params.require(:user).permit(:name, :unique_name, :email, :password, :password_confirmation, :icon, :profile)
  end

  def setting_params
    params.permit(:notice_of_like, :notice_of_reply, :notice_of_comment, :notice_of_follow)
  end

  def correct_user
    @user = User.find(params[:id])
    unless current_user == @user
      redirect_to root_url
      flash[:danger] = '許可されていないリクエストです'
    end
  end

  def create_settings
    settings = @user.build_setting
    settings.save
  end
end
