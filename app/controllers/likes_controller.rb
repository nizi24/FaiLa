class LikesController < ApplicationController

  def create
    if params[:article_id]
      @like = current_user.likes.build(article_id: params[:article_id])
      redirect_back(fallback_location: root_path) if @like.save
    elsif params[:comment_id]
      @like = current_user.likes.build(comment_id: params[:comment_id])
      redirect_back(fallback_location: root_path) if @like.save
    else
      redirect_to root_url
    end
  end

  def destroy
  end

end
