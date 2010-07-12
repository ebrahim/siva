class SynonymiesController < ApplicationController
	require_role :editor, :except => [ :index, :search, :show, :auto_complete_model_for_word_form, :auto_complete_model_for_word_form_verbose ]

	def index
	end

	def search
		word_form = params[:word_form]
		domain_id = params[:domain_id]
		word_form_set = !word_form.nil? && !word_form.blank?
		domain_set = !domain_id.nil? && !domain_id.blank?
		if word_form_set and domain_set
			@synonymies = Synonymy.paginate :page => params[:page], \
			  :include => [ { :word1 => :word_forms }, { :word2 => :word_forms } ], \
			  :conditions => [ 'LOWER(word_forms.text) LIKE ? AND domain_id = ?', "%#{word_form}%", domain_id ]
		elsif word_form_set
			@synonymies = Synonymy.paginate :page => params[:page], \
			  :include => [ { :word1 => :word_forms }, { :word2 => :word_forms } ], \
			  :conditions => [ 'LOWER(word_forms.text) LIKE ?', "%#{word_form}%" ]
		elsif domain_set
			@synonymies = Synonymy.paginate :page => params[:page], \
			  :conditions => { :domain_id => domain_id }
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
		@word_forms = WordForm.find :all, :limit => 10, :select => :text, :group => :text, \
			:conditions => [ 'LOWER(text) LIKE ?', "%#{params[:word_form]}%" ]
		render :inline => '<ul>
<% for word_form in @word_forms %>
<li id=""><%= h word_form.text %></li>
<% end %>
</ul>'
	end

	def auto_complete_model_for_word_form_verbose
		@word_forms = WordForm.find :all, :limit => 10, :select => :word_id, :group => :word_id, \
			:conditions => [ 'LOWER(text) LIKE ?', "%#{params[:word_form_verbose]}%" ]
		render :inline => '<ul>
<% for word_form in @word_forms %>
<li id="<%= word_form.word_id %>"><%= h "#{forms_summary(word_form.word)} -> #{word_form.word.language.name}" %></li>
<% end %>
</ul>'
	end
end
