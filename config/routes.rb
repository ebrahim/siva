ActionController::Routing::Routes.draw do |map| 
	# Restful Authentication Rewrites
	map.logout '/logout', :controller => 'sessions', :action => 'destroy'
	map.login '/login', :controller => 'sessions', :action => 'new'
	map.register '/register', :controller => 'users', :action => 'create'
	map.signup '/signup', :controller => 'users', :action => 'new'
	map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
	map.forgot_password '/forgot_password', :controller => 'passwords', :action => 'new'
	map.change_password '/change_password/:reset_code', :controller => 'passwords', :action => 'reset'
	map.open_id_complete '/opensession', :controller => 'sessions', :action => 'create', :requirements => { :method => :get }
	map.open_id_create '/opencreate', :controller => 'users', :action => 'create', :requirements => { :method => :get }
  
	# Restful Authentication Resources
	map.resources :users, :member => { :passwd => :get, :suspend => :get, :unsuspend => :get }
	map.resources :passwords
	map.resource :session
  
	# Home Page
	map.root :controller => 'application', :action => 'index'
	#map.root :controller => 'words', :action => 'index'

	# RESTful resources
	map.resources :words, :collection => { :search => :get }
	map.resources :synonymies, :collection => { :search => :get }
	map.resources :domains
	map.resources :languages
	map.resources :comments

	# Install the default routes as the lowest priority.
	map.connect ':controller/:action/:id'
	map.connect ':controller/:action/:id.:format'
end

#ActionController::Routing::Translator.i18n 'en'
ActionController::Routing::Translator.translate_from_file 'config', 'routes-i18n.yml'
