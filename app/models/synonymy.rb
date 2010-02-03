class Synonymy < ActiveRecord::Base
	belongs_to :category
	belongs_to :word1, :class_name => 'Word'
	belongs_to :word2, :class_name => 'Word'

	validates_presence_of :word1
	validates_presence_of :word2
	validates_uniqueness_of :word1, :scope => :word2
	validates_uniqueness_of :word2, :scope => :word1
end
