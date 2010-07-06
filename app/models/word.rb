class Word < ActiveRecord::Base
	belongs_to :language
	has_many :word_forms, :dependent => :destroy
	has_many :synonymies, :foreign_key => :word1_id, :dependent => :destroy
	has_many :synonymies, :foreign_key => :word2_id, :dependent => :destroy

	validates_presence_of :language

	accepts_nested_attributes_for :word_forms, :allow_destroy => true, :reject_if => lambda { |a| a[:text].blank? }
end
