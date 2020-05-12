class LikesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    @like = current_user.likes.build(likeable_id: params[:likeable_id],
                                     likeable_type: params[:likeable_type])
    if @like.save
      create_notice
      redirect_back(fallback_location: root_path)
    else
      redirect_to root_url
    end
  end

  def destroy
    @like = Like.find_by(likeable_id:   params[:likeable_id],
                         likeable_type: params[:likeable_type],
                         user_id:       current_user.id)
    @like.destroy if @like
    redirect_back(fallback_location: root_path)
  end


  private

  def create_notice
    if params[:user_id].to_i != current_user.id
      object_type = "#{params[:likeable_type].downcase}"
      @notice = Notification.new(received_user_id: params[:user_id],
                                 action_user_id:   current_user.id,
                                 message:          "@#{current_user.unique_name}さんがあなたの投稿にいいねしました",
                                 link:             "/#{object_type}s/#{params[:likeable_id]}")
      @notice.save
    end
  end
end
