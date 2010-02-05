class Word < ActiveRecord::Base
	belongs_to :locale
	has_many :word_forms, :dependent => :destroy
	has_many :synonymies, :foreign_key => :word1_id, :dependent => :destroy
	has_many :synonymies, :foreign_key => :word2_id, :dependent => :destroy

	validates_presence_of :locale
end
