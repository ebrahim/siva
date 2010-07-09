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

	def auto_complete_model_for_word_form_text
		@word_forms = WordForm.find(
			:all,
			:conditions => ['LOWER(text) LIKE ?', "%#{params[:word_form][:text]}%"],
			:limit => 10
		)
		render :inline => '
		<ul>
		<% for word_form in @word_forms %>
			<li id="<%= word_form.word_id %>"><%=h word_form.text %></li>
		<% end %>
		</ul>'
	end
end
