class Language < ActiveRecord::Base
	has_many :words, :dependent => :destroy

	has_localized :name

	validates_presence_of :name
	validates_presence_of :code
	validates_uniqueness_of :name
	validates_uniqueness_of :code
	validates_size_of :name, :within => 2..32
	validates_size_of :code, :within => 2..3
end
