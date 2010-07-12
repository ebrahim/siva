class WordsController < ApplicationController
	require_role :editor, :except => [ :index, :search, :show, :auto_complete_model_for_word_form ]

	def index
	end

	def search
		word_form = params[:word_form]
		word_form_set = !word_form.nil? && !word_form.blank?
		if word_form_set
			@words = Word.paginate :page => params[:page], :include => :word_forms,\
			  :conditions => [ 'LOWER(word_forms.text) LIKE ?', "%#{word_form}%" ]
		else
			@words = Word.paginate :page => params[:page]
		end
		if @words.blank?
			flash[:warning] = t(:not_found)
		end
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
			flash[:error] = @word.errors.full_messages
			render :action => :new
		end
	end

	def update
		@word = Word.find params[:id]
		if @word.update_attributes params[:word]
			flash[:notice] = t :word_updated
			redirect_to @word
		else
			flash[:error] = @word.errors.full_messages
			redirect_to :action => :edit
		end
	end

	def destroy
		@word = Word.find params[:id]
		@word.destroy
		flash[:notice] = t :word_removed
		redirect_to :action => :index
	end

	def auto_complete_model_for_word_form
		@word_forms = WordForm.find :all, :limit => 10, :group => :text, \
			:conditions => [ 'LOWER(text) LIKE ?', "%#{params[:word_form]}%" ]
		render :inline => '<ul>
<% for word_form in @word_forms %>
<li id="<%= word_form.word_id %>"><%= h word_form.text %></li>
<% end %>
</ul>'
	end
end
