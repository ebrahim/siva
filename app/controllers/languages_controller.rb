class LanguagesController < ApplicationController
	require_role :admin

	def index
		@languages = Language.all
	end

	def new
		@language = Language.new
	end

	def edit
		@language = Language.find params[:id]
	end

	def show
		@language = Language.find params[:id]
	end

	def create
		@language = Language.new params[:language]
		if @language.save
			flash[:notice] = t :language_created
			redirect_to :action => :index
		else
			flash[:error] = @language.errors.full_messages
			render :action => :new
		end
	end

	def update
		@language = Language.find params[:id]
		if @language.update_attributes params[:language]
			flash[:notice] = t :language_updated
			redirect_to @language
		else
			flash[:error] = @language.errors.full_messages
			redirect_to :action => :edit
		end
	end

	def destroy
		@language = Language.find params[:id]
		@language.destroy
		flash[:notice] = t :language_removed
		redirect_to :action => :index
	end

end
