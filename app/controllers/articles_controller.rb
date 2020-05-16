class ArticlesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    @articles = Article.all_page(params[:page])
    @microposts = Micropost.all_page(params[:page])
  end

  def show
    @article = Article.find(params[:id])
    @user = @article.user #followパーシャルにローカル変数を渡すとエラーが起こった 原因不明
    @comments = @article.comments
    if logged_in?
      @comment = current_user.comments.build(article_id: params[:id])
    end
  end

  def new
    @article = Article.new
  end

  def create
    @article = current_user.articles.build(article_params)
    if @article.save
      redirect_to articles_url
      flash[:success] = '投稿が完了しました'
    else
      render 'new'
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    if @article.update(article_params)
      flash[:success] = '更新に成功しました'
      redirect_to @article
    else
      render 'edit'
    end
  end

  def destroy
    @article = Article.find(params[:id])
    if @article.destroy
      flash[:success] = '削除しました'
      redirect_to articles_url
    end
  end

private

  def article_params
    params.require(:article).permit(:title, :content)
  end

  def correct_user
    @article = Article.find(params[:id])
    unless current_user == @article.user
      flash[:danger] = '許可されていないリクエストです'
      redirect_to root_url
    end
  end

end
