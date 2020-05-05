class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: [:destroy]

  def index
  end

  def show
    @micropost = Micropost.find(params[:id])
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = '投稿しました'
      redirect_back(fallback_location: root_path)
    else
      redirect_to root_url
    end
  end

  def destroy
    @micropost = Micropost.find(params[:id])
    if @micropost.destroy
      flash[:info] = '投稿を削除しました'
      redirect_to articles_path
    end
  end

  private
    def micropost_params
      params.require(:micropost).permit(:content)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      if @micropost.nil?
        flash[:danger] = '許可されていないリクエストです'
        redirect_to root_url
      end
    end
end
