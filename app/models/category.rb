class Category < ActiveRecord::Base
	acts_as_nested_set
	validates_uniqueness_of :name, :scope => :parent_id
end
