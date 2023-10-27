class CommentsController < ApplicationController
  def create
    @commentable = commentable
    @comment = @commentable.comments.build(comment_params)
    @comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(user: current_user)
  end

  def commentable
    params.each_key do |key|
      match = key.match(/(.+)_id\z/)
      if match
        votable_type = key.match(/(.+)_id/)[1]
        return votable_type.classify.constantize.find(params[key])
      end
    end
  end
end
