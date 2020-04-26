class CommentsController < ApplicationController
before_action :logged_in_user, only: [:create, :destroy]
before_action :correct_user, only: [:destroy]

  def create
    article = Article.find(params[:comment][:article_id])
    @comment = article.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      flash[:success] = 'コメントしました'
      redirect_back(fallback_location: root_path)
    else
      flash[:danger] = 'コメントできませんでした'
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      flash[:success] = 'コメントを削除しました'
      redirect_back(fallback_location: root_path)
    end
  end

private

  def comment_params
    params.require(:comment).permit(:content, :article_id)
  end

  def correct_user
    @comment = Comment.find(params[:id])
    unless current_user == @comment.user
      flash[:danger] = '許可されていないリクエストです'
      redirect_to root_url
    end
  end
  
end
