class Domain < ActiveRecord::Base
	acts_as_nested_set

	has_many :synonymies, :dependent => :nullify

	validates_presence_of :name
	validates_uniqueness_of :name, :scope => :parent_id
end
