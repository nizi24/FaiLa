class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  USER_UNIQUE_NAME_REGEX = /@([a-z0-9_]{5,15})/i

  def show
    @micropost = Micropost.find(params[:id])
    @sended_replies = @micropost.sended_replies
    @received_replies = @micropost.received_replies
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save

      #リプライをする場合
      #@unique_nameが含まれている場合
      @unique_names = @micropost.content.scan(USER_UNIQUE_NAME_REGEX)
      if @unique_names.any?
        create_reply
      #返信先のつぶやきが存在し、@unique_nameが含まれていない場合
      elsif params[:received_micropost_id]
        create_reply_to_micropost
      end

      flash[:success] = '投稿しました'
      redirect_back(fallback_location: root_path)
    else
      redirect_to root_url
    end
  end

  def destroy
    @micropost = Micropost.find(params[:id])
    if @micropost.destroy
      flash[:info] = '投稿を削除しました'
      redirect_to root_url
    end
  end

  private
    def micropost_params
      params.require(:micropost).permit(:content)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      if @micropost.nil?
        flash[:danger] = '許可されていないリクエストです'
        redirect_to root_url
      end
    end

    def create_reply
      if @unique_names.any?
        #マッチしたユーザー名からユーザーを捕捉して配列にする
        users = []
        @unique_names.each do |unique_name|
          if user = User.find_by(unique_name: unique_name[0].downcase)
            users << user
          end
        end

        #リプライを作成
        users.each do |user|
          @reply = current_user.send_replies.build(received_user_id: user.id,
                                                   sended_micropost_id: @micropost.id)
          @reply.save
          create_notice
        end
      end
      # 返信先のつぶやきが存在するとき
      if params[:received_micropost_id]
        create_reply_to_micropost
      end
    end

    def create_reply_to_micropost
      @reply = current_user.send_replies.build(received_user_id: params[:received_user_id],
                                               sended_micropost_id: @micropost.id,
                                               received_micropost_id: params[:received_micropost_id])
      @reply.save
      # リプライ先のユーザー名をcontentに追加
      user = User.find(params[:received_user_id])
      @micropost.update(content: "@#{user.unique_name} #{@micropost.content}")
      create_notice
    end

    def create_notice
      user = User.find_by(id: @reply.received_user_id)
      if user.setting.notice_of_reply #ユーザーの設定を参照
        if @reply.received_user != current_user #自分で自分にリプライしても通知は作られない
          @notice = Notification.new(received_user_id: @reply.received_user_id,
                                     action_user_id: current_user.id,
                                     message: "@#{@micropost.user.unique_name}さんが返信しました。\r#{@micropost.content}",
                                     link: "/microposts/#{@micropost.id}")
          @notice.save
        end
      end
    end
end
