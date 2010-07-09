class SynonymiesController < ApplicationController
	def index
		@synonymies = Synonymy.all
		@synonymies.each do |syn|
			if syn.word1.language.name > syn.word2.language.name
				temp = syn.word1
				syn.word1 = syn.word2
				syn.word2 = temp
			end
		end
	end

	def show
		@synonymy = Synonymy.find params[:id]
	end

	def new
		@synonymy = Synonymy.new
	end

	def edit
		@synonymy = Synonymy.find params[:id]
	end

	def create
		@synonymy = Synonymy.new params[:synonymy]
		if @synonymy.save
			flash[:notice] = t :synonymy_created
			redirect_to @synonymy
		else
			flash[:error] = @synonymy.errors.full_messages
			render :action => :new
		end
	end

	def update
		@synonymy = Synonymy.find params[:id]
		if @synonymy.update_attributes params[:synonymy]
			flash[:notice] = t :synonymy_updated
			redirect_to @synonymy
		else
			flash[:error] = @synonymy.errors.full_messages
			redirect_to :action => :edit
		end
	end

	def destroy
		@synonymy = Synonymy.find params[:id]
		@synonymy.destroy
		flash[:notice] = t :synonymy_removed
		redirect_to :action => :index
	end
end
