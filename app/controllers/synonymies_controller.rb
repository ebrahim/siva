class SynonymiesController < ApplicationController
	def index
	end

	def search
		word_id = params[:word_id]
		category_id = params[:category_id]
		word_set = !word_id.nil? && !word_id.blank?
		category_set = !category_id.nil? && !category_id.blank?
		if word_set and category_set
			@synonymies = Synonymy.paginate :all, :page => params[:page], :conditions => \
				[ '(word1_id = ? OR word2_id = ?) AND category_id = ?', \
					word_id, word_id, category_id ]
		elsif word_set
			@synonymies = Synonymy.paginate :all, :page => params[:page], :conditions => \
				[ 'word1_id = ? OR word2_id = ?', word_id, word_id ]
		elsif category_set
			@synonymies = Synonymy.paginate :all, :page => params[:page], :conditions => { :category_id => category_id }
		else
			@synonymies = Synonymy.paginate :page => params[:page]
		end
		@synonymies.each do |syn|
			if syn.word1.language.name > syn.word2.language.name
				temp = syn.word1
				syn.word1 = syn.word2
				syn.word2 = temp
			end
		end
		if @synonymies.blank?
			flash[:warning] = t(:not_found)
		end
	end

	def show
		@synonymy = Synonymy.find params[:id]
	end

	def new
		@synonymy = Synonymy.new
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

	def destroy
		@synonymy = Synonymy.find params[:id]
		@synonymy.destroy
		flash[:notice] = t :synonymy_removed
		redirect_to :action => :index
	end

	def auto_complete_model_for_word_form_text
		@word_forms = WordForm.find(
			:all,
			:conditions => ['LOWER(text) LIKE ?', "%#{params[:word_form][:text]}%"],
			:limit => 10
		)
		render :inline => '<ul>
<% for word_form in @word_forms %>
<li id="<%= word_form.word_id %>"><%=h word_form.text %></li>
<% end %>
</ul>'
	end
end
