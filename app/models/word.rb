class Word < ActiveRecord::Base
	cattr_reader :per_page
	@@per_page = 7

	default_scope :order => 'language_id ASC'

	belongs_to :language
	has_many :word_forms, :dependent => :destroy
	has_many :synonymies, :foreign_key => :word1_id
	has_many :synonymies, :foreign_key => :word2_id

	before_save do |word|
		word.word_forms.sort! { |a,b| a.text <=> b.text }
		word.word_forms = word.word_forms.inject([]) do |result, item|
			result << item if not result.last or (not item.text.blank? and result.last.text != item.text)
			result
		end
		if word.word_forms.blank?
			word.errors.add :word_forms, I18n.t(:'activerecord.errors.models.word.attributes.word_forms.too_short')
			false
		end
	end

	after_destroy do |word|
		Synonymy.destroy_all :word1_id => word.id
		Synonymy.destroy_all :word2_id => word.id
	end

	validates_presence_of :language

	accepts_nested_attributes_for :word_forms, :allow_destroy => true, :reject_if => lambda { |params| params[:text].blank? }
end
