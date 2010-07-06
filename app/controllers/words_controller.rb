class WordsController < ApplicationController
	def index
		@words = Word.all
	end

	def show
		@word = Word.find params[:id]
	end

	def new
		@word = Word.new
		@word.word_forms.build
	end

	def edit
		@word = Word.find params[:id]
	end

	def create
		@word = Word.new params[:word]
		if @word.save
			flash[:notice] = t :word_created
			redirect_to @word
		else
			render :action => :new
		end
	end

	def update
		@word = Word.find params[:id]
		if @word.update_attributes params[:word]
			flash[:notice] = t :word_updated
			redirect_to @word
		else
			redirect_to :action => :edit
		end
	end

	def destroy
		@word = Word.find params[:id]
		@word.destroy
		flash[:notice] = t :word_removed
		redirect_to :action => :index
	end
end
