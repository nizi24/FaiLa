class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: [:destroy]
  # before_action :correct_reply,  only: [:create]


  def show
    @micropost = Micropost.find(params[:id])
    @sended_replies = @micropost.sended_replies
    @received_replies = @micropost.received_replies
    @like = Like.find_by(id: 1..100)
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      if params[:received_user_id]
        create_reply
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

    # def correct_reply
    #   reply = Reply.find_by(received_user_id: params[:received_user_id])
    #   if reply.nil? && params[:received_user_id]
    #     create_reply
    #   else
    #     true
    #   end
    # end

    def create_reply
      @reply = current_user.send_replies.build(received_user_id: params[:received_user_id],
                                               sended_micropost_id: @micropost.id)
      if params[:received_micropost_id]
        @reply.received_micropost_id = params[:received_micropost_id]
      end
      @reply.save
    end
end
