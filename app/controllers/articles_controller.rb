class ArticlesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :destroy]
  before_action :correct_user, only: [:destroy]

  def index
    @articles = Article.all_page(params[:page])
    @microposts = Micropost.all_page(params[:page])
    @micropost_like = Like.micropost_like(current_user) if logged_in?
  end

  def show
    @article = Article.find(params[:id])
    @comments = @article.comments
    if logged_in?
      @comment = current_user.comments.build(article_id: params[:id])
      @article_like = Like.article_like(current_user)
      @comment_like = Like.comment_like(current_user)
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
