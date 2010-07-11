class SynonymiesController < ApplicationController
	def index
	end

	def search
		word_form = params[:word_form]
		category_id = params[:category_id]
		word_form_set = !word_form.nil? && !word_form.blank?
		category_set = !category_id.nil? && !category_id.blank?
		if word_form_set and category_set
			@synonymies = Synonymy.paginate :page => params[:page], \
			  :include => [ { :word1 => :word_forms }, { :word2 => :word_forms } ], \
			  :conditions => [ 'LOWER(word_forms.text) LIKE ? AND category_id = ?', "%#{word_form}%", category_id ]
		elsif word_form_set
			@synonymies = Synonymy.paginate :page => params[:page], \
			  :include => [ { :word1 => :word_forms }, { :word2 => :word_forms } ], \
			  :conditions => [ 'LOWER(word_forms.text) LIKE ?', "%#{word_form}%" ]
		elsif category_set
			@synonymies = Synonymy.paginate :page => params[:page], \
			  :conditions => { :category_id => category_id }
		else
			@synonymies = Synonymy.paginate :page => params[:page]
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
