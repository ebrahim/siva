class WordForm < ActiveRecord::Base
	belongs_to :word

	default_scope :order => 'text ASC'

	validates_presence_of :text
	validates_uniqueness_of :text, :scope => :word_id
	validates_length_of :text, :within => 2..128
end
