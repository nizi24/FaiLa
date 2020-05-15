class RelationshipsController < ApplicationController
before_action :logged_in_user

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    create_notice
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  private

  def create_notice
    if @user.setting.notice_of_follow #ユーザーの設定を参照
      if @user != current_user
        @notice = Notification.new(received_user_id: @user.id,
                                   action_user_id: current_user.id,
                                   message: "@#{current_user.unique_name}さんがあなたをフォローしました",
                                   link: "/users/#{current_user.id}")
        @notice.save
      end
    end
  end
end
