class CommentsController < ApplicationController
	require_role :admin

	def destroy
		@comment = Comment.find params[:id]
		commentable = @comment.commentable
		@comment.destroy
		flash[:notice] = t :comment_removed
		redirect_to commentable
	end
end
