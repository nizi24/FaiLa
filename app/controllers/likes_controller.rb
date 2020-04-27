class LikesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: [:destroy]


  def create
    if params[:article_id]
      @article = Article.find(params[:article_id])
      @like = @article.likes.build
      @like.user_id = current_user.id
      redirect_back(fallback_location: root_path) if @like.save
    elsif params[:comment_id]
      @comment = Comment.find(params[:comment_id])
      @like = @comment.likes.build
      @like.user_id = current_user.id
      redirect_back(fallback_location: root_path) if @like.save
    else
      redirect_to root_url
    end
  end



  def destroy
    if params[:article_id]
      @like = Like.find_by(likeable_id: params[:article_id], likeable_type: "Article",  user_id: current_user.id)
    elsif params[:comment_id]
      @like = Like.find_by(likeable_id: params[:comment_id], likeable_type: "Comment", user_id: current_user.id)
    end
    @like.destroy
    redirect_back(fallback_location: root_path)
  end

private

  def correct_user
    @like = Like.find_by(likeable_id: params[:id])
    unless current_user == @like.user
      flash[:danger] = '許可されていないリクエストです'
      redirect_to root_url
    end
  end

end
