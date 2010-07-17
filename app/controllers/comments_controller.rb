class CommentsController < ApplicationController
	require_role :editor
	require_role :admin, :only => [ :destroy ]

	def create
		@comment = Comment.create params[:comment]
		@comment.user = current_user
		@synonymy = Synonymy.find @comment.commentable_id
		@synonymy.comments << @comment
		if @comment.errors.blank?
			flash[:notice] = t :comment_created
		else
			flash[:error] = @comment.errors.full_messages
		end
		redirect_to @synonymy
	end

	def destroy
		@comment = Comment.find params[:id]
		commentable = @comment.commentable
		@comment.destroy
		flash[:notice] = t :comment_removed
		redirect_to commentable
	end
end
