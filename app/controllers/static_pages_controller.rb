class StaticPagesController < ApplicationController

  def home
    if logged_in?
      # タイムライン
      @following_feed_items = current_user.following_feed
      @following_feed_articles = current_user.following_articles_feed
      @following_feed_microposts = current_user.following_microposts_feed

      # トレンド(記事)
      @article_trend_recent = Article.rank(3.days)
      @article_trend_week =   Article.rank(1.week)
      @article_trend_month =  Article.rank(1.month)

      # トレンド(つぶやき)
      @micropost_trend_recent = Micropost.rank(3.days)
      @micropost_trend_week =   Micropost.rank(1.week)
      @micropost_trend_month =  Micropost.rank(1.month)
    end
  end

  def search
    @search_kyeword = params[:search]
    @user_results = User.search(params[:search])
    @article_results = Article.search(params[:search])
    @micropost_results = Micropost.search(params[:search])
    if params[:search].gsub!(/\A@/, '')
      @user_results += User.unique_name_search(params[:search])
    end
  end

  def about
  end

  def help
  end

end

git filter-branch -f --env-filter "GIT_AUTHOR_NAME='nizi'; GIT_AUTHOR_EMAIL='failaforcontact@gmail.com'; GIT_COMMITTER_NAME='nizi'; GIT_COMMITTER_EMAIL='failaforcontact@gmail.com';" HEAD
