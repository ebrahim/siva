class CategoriesController < ApplicationController
	def index
		@categories = Category.all
	end

	def show
		@category = Category.find params[:id]
		@parent_category = Category.find @category.parent_id unless @category.parent_id.blank?
	end

	def new
		@category = Category.new
	end

	def edit
		@category = Category.find params[:id]
	end

	def create
		@category = Category.new params[:category]
		if @category.save
			flash[:notice] = t :category_created
			redirect_to @category
		else
			flash[:error] = @category.errors.full_messages
			render :action => :new
		end
	end

	def update
		@category = Category.find params[:id]
		if @category.update_attributes params[:category]
			flash[:notice] = t :category_updated
			redirect_to @category
		else
			flash[:error] = @category.errors.full_messages
			redirect_to :action => :edit
		end
	end

	def destroy
		@category = Category.find params[:id]
		@category.destroy
		flash[:notice] = t :category_removed
		redirect_to :action => :index
	end
end
