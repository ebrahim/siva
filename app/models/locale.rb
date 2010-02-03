class Locale < ActiveRecord::Base
	has_many :words, :dependent => :nullify
	validates_uniqueness_of :iso_code
	validates_presence_of :name
end
