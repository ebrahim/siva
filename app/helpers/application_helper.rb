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
			messages << content_tag(:div, html_escape(flash[msg.to_sym]), :id => "flash-#{msg}") unless flash[msg.to_sym].blank?
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

end
