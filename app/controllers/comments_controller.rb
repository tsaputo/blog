class CommentsController < ApplicationController
    
  before_action :logged_in_user
  before_action :find_commentable, only: :create

  def new
    @comment = Comment.new
  end


  def create
    
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    @comment.save

    redirect_back fallback_location: root_path
  end

  def destroy
      @comment = Comment.find(params[:id])
      if (current_user ===  @comment.user)
        @comment.destroy
      else 
        flash[:danger] = "You dont have permission to delete this comment"
      end
      redirect_back fallback_location: root_path
  end

  def find_commentable
    if params[:comment_id]
      @commentable = Comment.find_by_id(params[:comment_id]) 
    elsif params[:article_id]
      @commentable = Article.find_by_id(params[:article_id])
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:body)
  end
end