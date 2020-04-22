class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user &&  user.authenticate(params[:session][:password])
      log_in(user)
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      flash[:success] = 'ログインに成功しました'
      redirect_to user
    else
      flash[:danger] = 'ログインに失敗しました'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    flash[:info] = 'ログアウトしました'
    redirect_to login_path
  end
  
end
