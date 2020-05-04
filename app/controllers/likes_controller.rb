class LikesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    @like = current_user.likes.build(likeable_id: params[:likeable_id], likeable_type: params[:likeable_type])
    if @like.save
      redirect_back(fallback_location: root_path)
    else
      redirect_to root_url
    end
  end

  def destroy
    @like = Like.find_by(likeable_id: params[:likeable_id], likeable_type: params[:likeable_type], user_id: current_user.id)
    @like.destroy if @like
    redirect_back(fallback_location: root_path)
  end

end
