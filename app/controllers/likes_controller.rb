class LikesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: [:destroy]


  def create
    if object = sort_like_object
      @like = object.likes.build
      @like.user_id = current_user.id
      redirect_back(fallback_location: root_path) if @like.save
    else
      redirect_to root_url
    end
  end



  def destroy
    if sort_liked_object
      @like = Like.find_by(sort_liked_object)
    else
      redirect_to root_url
    end
    @like.destroy if @like
    redirect_back(fallback_location: root_path)
  end

private

  #destroyでcurrent_userがいいねしているかどうか確かめるのでいらないかも？
  def correct_user
    unless current_user.already_liked?(sort_params)
      flash[:danger] = '許可されていないリクエストです'
      redirect_to root_url
    end
  end

  #likeする対象を分類
  def sort_like_object
    if params[:article_id]
      Article.find(params[:article_id])
    elsif params[:comment_id]
      Comment.find(params[:comment_id])
    end
  end

  #likeされている対象を分類
  def sort_liked_object
    liked_object_hash = { user_id: current_user.id }
    if params[:article_id]
      liked_object_hash.merge({ likeable_id: params[:article_id], likeable_type: 'Article'})
    elsif params[:comment_id]
      liked_object_hash.merge({ likeable_id: params[:comment_id], likeable_type: 'Comment'})
    else
      liked_object_hash = nil
    end
  end

  #paramsを分類　いらないかも？
  def sort_params
    if params[:article_id]
      params[:article_id]
    elsif params[:comment_id]
      params[:comment_id]
    end
  end
end
