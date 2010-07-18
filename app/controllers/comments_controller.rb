class CommentsController < ApplicationController
	require_role :admin, :except => [ :create ]
	require_role :editor

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

	def edit
		@comment = Comment.find params[:id]
	end

	def update
		@comment = Comment.find params[:id]
		if @comment.update_attributes params[:comment]
			flash[:notice] = t :comment_updated
			redirect_to @comment.commentable
		else
			flash[:error] = @comment.errors.full_messages
			redirect_to :action => :edit
		end
	end

	def destroy
		@comment = Comment.find params[:id]
		commentable = @comment.commentable
		@comment.destroy
		flash[:notice] = t :comment_removed
		redirect_to commentable
	end
end
