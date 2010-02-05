class LocalesController < ApplicationController
	def index
		@locales = Locale.all
	end

	def new
		@locale = Locale.new
	end

	def edit
		@locale = Locale.find params[:id]
	end

	def show
		@locale = Locale.find params[:id]
	end

	def create
		@locale = Locale.new params[:locale]
		if @locale.save
			flash[:notice] = 'Locale was created successfully'
			redirect_to :action => :index
		else
			render :action => :new
		end
	end

	def update
		@locale = Locale.find params[:id]
		if @locale.update_attributes params[:locale]
			flash[:notice] = "Locale was updated successfully"
			redirect_to @locale
		else
			redirect_to :action => :edit
		end
	end

	def destroy
		@locale = Locale.find params[:id]
		@locale.destroy
		flash[:notice] = "Locale was removed successfully"
		redirect_to :action => :index
	end

end
