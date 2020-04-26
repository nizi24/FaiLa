class ArticlesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :destroy]
  before_action :correct_user, only: [:destroy]

  def index
    @articles = Article.all.order(created_at: :desc).paginate(page: params[:page])
  end

  def show
    @article = Article.find(params[:id])
    @comment = current_user.comments.build(article_id: params[:id]) if logged_in?
    @comments = @article.comments
    @likes_article = Article.where(article_id: params[:id])
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
