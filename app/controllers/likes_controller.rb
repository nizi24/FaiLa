class LikesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    @like = current_user.likes.build(likeable_id: params[:likeable_id],
                                     likeable_type: params[:likeable_type])
    if @like.save
      create_notice
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path) }
        format.js { sort_object }
      end

    else
      redirect_to root_url
    end
  end


  def destroy
    @like = Like.find_by(likeable_id:   params[:likeable_id],
                         likeable_type: params[:likeable_type],
                         user_id:       current_user.id)
    @like.destroy if @like

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js { sort_object }
    end

  end


  private

  def create_notice
    user = User.find_by(id: params[:user_id])
    if user.setting.notice_of_like #相手のユーザーの設定を参照
      if params[:user_id].to_i != current_user.id #自分のいいねでは通知は作られない
        object_type = "#{params[:likeable_type].downcase}"
        @notice = Notification.new(received_user_id: params[:user_id],
                                   action_user_id:   current_user.id,
                                   message:          "@#{current_user.unique_name}さんがあなたの投稿にいいねしました",
                                   link:             "/#{object_type}s/#{params[:likeable_id]}")
        @notice.save
      end
    end
  end

  # ajax用処理
  def sort_object
    if 'Article' == params[:likeable_type]
      @object = Article.find(params[:likeable_id])
      @form_id = "article-#{@object.id}"
    elsif 'Comment' == params[:likeable_type]
      @object = Comment.find(params[:likeable_id])
      @form_id = "comment-#{@object.id}"
    else
      @object = Micropost.find(params[:likeable_id])
      @form_id = "micropost-#{@object.id}"
    end
  end
end
