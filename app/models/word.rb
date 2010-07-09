class Word < ActiveRecord::Base
	belongs_to :language
	has_many :word_forms, :dependent => :destroy
	has_many :synonymies, :foreign_key => :word1_id
	has_many :synonymies, :foreign_key => :word2_id

	after_destroy do |word|
		Synonymy.destroy_all :word1_id => word.id
		Synonymy.destroy_all :word2_id => word.id
	end

	validates_presence_of :language
	#validates_size_of :word_forms, :minimum => 1		# FIXME: Disables destoying word_forms

	accepts_nested_attributes_for :word_forms, :allow_destroy => true, :reject_if => lambda { |params| params[:text].blank? }
end
