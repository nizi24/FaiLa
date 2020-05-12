class RelationshipsController < ApplicationController
before_action :logged_in_user

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    create_notice
    redirect_to @user
  end

  def destroy
    user = Relationship.find(params[:id]).followed
    current_user.unfollow(user)
    redirect_to user
  end

  private

  def create_notice
    if @user != current_user
      @notice = Notification.new(received_user_id: @user.id,
                                 action_user_id: current_user.id,
                                 message: "@#{current_user.unique_name}さんがあなたをフォローしました",
                                 link: "/users/#{current_user.id}")
      @notice.save
    end
  end
end
