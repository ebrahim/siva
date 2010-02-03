class WordRepresentation < ActiveRecord::Base
	belongs_to :word
	validates_presence_of :text
	validates_uniqueness_of :text
end
