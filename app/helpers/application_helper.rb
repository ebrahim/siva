module ApplicationHelper
  
	# Sets the page title and outputs title if container is passed in.
	# eg. <%= title('Hello World', :h2) %> will return the following:
	# <h2>Hello World</h2> as well as setting the page title.
	def title(str, container = nil)
		@page_title = str
		content_tag(container, str) if container
	end
  
	# Outputs the corresponding flash message if any are set
	def flash_messages
		messages = []
		%w(notice warning error).each do |msg|
			flash_msg = flash[msg.to_sym]
			flash_msg = [flash_msg] unless flash_msg.blank? or flash_msg.kind_of? Array
			messages << content_tag(:div, raw(flash_msg.map { |m| html_escape m }.join '<br/>'), :id => "flash-#{msg}") unless flash_msg.blank?
			flash[msg.to_sym] = []
		end
		messages
	end

	def link_to_add_fields(name, form, association)
		new_object = form.object.class.reflect_on_association(association).klass.new
		fields = form.semantic_fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
			render(association.to_s.singularize + "_fields", :f => builder)
		end
		link_to_function name, h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
	end

	def link_to_back
		link_to t(:form_back), :back
	end

	def paginate(list)
		will_paginate list, :next_label => t(:form_next), :previous_label => t(:form_previous), :container => false
	end

	def siva_title(controller = nil, action = nil)
		title_text = t(:siva)
		title_text += ' :: ' + t(controller) if controller
		title_text += ' :: ' + t(action) if action
		title title_text, :h2
	end

	def switch_language_links
		links = ''
		orig_locale = I18n.locale
		Language.all.each do |lang|
			if I18n.available_locales.index lang.code.to_sym
				I18n.locale = lang.code.to_sym
				lang_name = lang.name
				lang_name = lang.code unless lang_name && !lang_name.blank?
				links << (link_to(lang_name, '/' + lang.code) + '<br/>') \
					unless (lang.code == orig_locale.to_s) || (lang.code == I18n.default_locale.to_s)
				links << (link_to(lang_name, '/') + '<br/>') \
					if (lang.code != orig_locale.to_s) && (lang.code == I18n.default_locale.to_s)
			end
		end
		I18n.locale = orig_locale
		links
	end
	
	# Only for hiding irrelevant links in views
	def can_access?(action, resource)
		return false unless logged_in? && current_user && !current_user.blank?
		return true if current_user.has_role?('admin')
		return false if action == :destroy || action == :suspend || action == :unsuspend || resource == :domains || resource == :languages
		true
	end
end
