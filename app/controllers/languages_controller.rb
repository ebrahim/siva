class LanguagesController < ApplicationController
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
			flash[:notice] = 'Language was created successfully'
			redirect_to :action => :index
		else
			render :action => :new
		end
	end

	def update
		@language = Language.find params[:id]
		if @language.update_attributes params[:language]
			flash[:notice] = "Language was updated successfully"
			redirect_to @language
		else
			redirect_to :action => :edit
		end
	end

	def destroy
		@language = Language.find params[:id]
		@language.destroy
		flash[:notice] = "Language was removed successfully"
		redirect_to :action => :index
	end

end
