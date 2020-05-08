class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: [:destroy]
  
  USER_UNIQUE_NAME_REGEX = /@([a-z0-9_]{5,15})/i

  def show
    @micropost = Micropost.find(params[:id])
    @sended_replies = @micropost.sended_replies
    @received_replies = @micropost.received_replies
    @like = Like.find_by(id: 1..100)
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save

      #つぶやきにリプライする場合
      if params[:received_user_id]
        create_reply_to_micropost

      #ユーザーにリプライする場合
      elsif @unique_names = @micropost.content.scan(USER_UNIQUE_NAME_REGEX)
        create_reply_to_user
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
      redirect_to articles_path
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

    def create_reply_to_micropost
      @reply = current_user.send_replies.build(received_user_id: params[:received_user_id],
                                               sended_micropost_id: @micropost.id,
                                               received_micropost_id: params[:received_micropost_id])
      @reply.save
    end

    def create_reply_to_user
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
      end
    end
end
