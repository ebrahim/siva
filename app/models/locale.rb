class Locale < ActiveRecord::Base
	has_many :words, :dependent => :destroy

	validates_presence_of :name
	validates_presence_of :iso_code
	validates_uniqueness_of :name
	validates_uniqueness_of :iso_code
end
