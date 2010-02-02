class Locale < ActiveRecord::Base
	has_many :words
	validates_uniqueness_of :iso_code
end
