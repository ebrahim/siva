class SynonymiesController < ApplicationController
	require_role :editor, :except => [ :index, :search, :show, :auto_complete_model_for_word_form, :auto_complete_model_for_word_form_verbose ]
	require_role :admin, :only => [ :destroy, :destroy_comment ]

	def index
	end

	def search
		word_form = params[:word_form]
		domain_id = params[:domain_id]
		word_form_set = !word_form.nil? && !word_form.blank?
		domain_set = !domain_id.nil? && !domain_id.blank?
		if word_form_set and domain_set
			@synonymies = Synonymy.paginate :page => params[:page], \
			  :joins => [ { :word1 => :word_forms }, { :word2 => :word_forms } ], :select => 'DISTINCT "synonymies".*', \
			  :conditions => [ '(LOWER(word_forms.text) LIKE ? OR LOWER(word_forms_words.text)) AND domain_id = ?', "%#{word_form.downcase}%", "%#{word_form.downcase}%", domain_id ]
		elsif word_form_set
			@synonymies = Synonymy.paginate :page => params[:page], \
			  :joins => [ { :word1 => :word_forms }, { :word2 => :word_forms } ], :select => 'DISTINCT "synonymies".*', \
			  :conditions => [ 'LOWER(word_forms.text) LIKE ? OR LOWER(word_forms_words.text) LIKE ?', "%#{word_form.downcase}%", "%#{word_form.downcase}%" ]
		elsif domain_set
			@synonymies = Synonymy.paginate :page => params[:page], \
			  :conditions => { :domain_id => domain_id }
		else
			@synonymies = Synonymy.paginate :page => params[:page]
		end
		if @synonymies.blank?
			flash[:warning] = t(:not_found)
		end
		@synonymies.each do |s|		# Fetch all 'word_forms'es from DB
			s.word1.word_forms(true)
			s.word2.word_forms(true)
		end
		respond_to do |format|
			format.html {}
			format.json { render :json => synonymy_to_json(@synonymies) }
			format.xml { render :xml => synonymy_to_xml(@synonymies) }
		end
	end

	def show
		@synonymy = Synonymy.find params[:id]
		@comment = Comment.new :commentable => @synonymy
		respond_to do |format|
			format.html {}
			format.json { render :json => synonymy_to_json(@synonymy) }
			format.xml { render :xml => synonymy_to_xml(@synonymy) }
		end
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
			:conditions => [ 'LOWER(text) LIKE ?', "%#{params[:word_form].downcase}%" ]
		render :inline => '<ul>
<% for word_form in @word_forms %>
<li id=""><%= h word_form.text %></li>
<% end %>
</ul>'
	end

	def auto_complete_model_for_word_form_verbose
		@word_forms = WordForm.find :all, :limit => 10, :select => :word_id, :group => :word_id, \
			:conditions => [ 'LOWER(text) LIKE ?', "%#{params[:word_form_verbose].downcase}%" ]
		render :inline => '<ul>
<% for word_form in @word_forms %>
<li id="<%= word_form.word_id %>"><%= h "#{forms_summary(word_form.word)} -> #{word_form.word.language.name}" %></li>
<% end %>
</ul>'
	end

	protected

	def synonymy_to_json(synonymy)
		synonymy.to_json(
				:except => [:created_at, :updated_at, :id, :domain_id, :word1_id, :word2_id],
				:include => {
					:word1 => {
						:except => [:created_at, :updated_at, :id, :language_id],
						:include => {
							:word_forms => { :only => [:text] },
							:language => { :only => [:code, :name, :rtl] }
						}
					},
					:word2 => {
						:except => [:created_at, :updated_at, :id, :language_id],
						:include => {
							:word_forms => { :only => [:text] },
							:language => { :only => [:code, :name, :rtl] }
						}
					},
					:domain => { :only => [:name] }
				}
			)
	end

	def synonymy_to_xml(synonymy)
		synonymy.to_xml(
				:except => [:created_at, :updated_at, :id, :domain_id, :word1_id, :word2_id],
				:include => {
					:word1 => {
						:except => [:created_at, :updated_at, :id, :language_id],
						:include => {
							:word_forms => { :only => [:text] },
							:language => { :only => [:code, :name, :rtl] }
						}
					},
					:word2 => {
						:except => [:created_at, :updated_at, :id, :language_id],
						:include => {
							:word_forms => { :only => [:text] },
							:language => { :only => [:code, :name, :rtl] }
						}
					},
					:domain => { :only => [:name] }
				}
			)
	end
end
