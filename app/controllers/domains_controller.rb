class DomainsController < ApplicationController
	require_role :admin

	def index
		@domains = Domain.all
	end

	def show
		@domain = Domain.find params[:id]
		@parent_domain = Domain.find @domain.parent_id unless @domain.parent_id.blank?
	end

	def new
		@domain = Domain.new
	end

	def edit
		@domain = Domain.find params[:id]
	end

	def create
		@domain = Domain.new params[:domain]
		if @domain.save
			flash[:notice] = t :domain_created
			redirect_to @domain
		else
			flash[:error] = @domain.errors.full_messages
			render :action => :new
		end
	end

	def update
		@domain = Domain.find params[:id]
		if @domain.update_attributes params[:domain]
			flash[:notice] = t :domain_updated
			redirect_to @domain
		else
			flash[:error] = @domain.errors.full_messages
			redirect_to :action => :edit
		end
	end

	def destroy
		@domain = Domain.find params[:id]
		@domain.destroy
		flash[:notice] = t :domain_removed
		redirect_to :action => :index
	end
end
