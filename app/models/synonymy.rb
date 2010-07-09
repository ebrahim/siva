class Synonymy < ActiveRecord::Base
	belongs_to :category
	belongs_to :word1, :class_name => 'Word'
	belongs_to :word2, :class_name => 'Word'

	validates_presence_of :word1
	validates_presence_of :word2
	validate do |synonymy|
		synonymy.errors.add_to_base I18n.t(:'activerecord.errors.models.synonymy.words_same') \
			if synonymy.word1 == synonymy.word2
		synonymy.errors.add_to_base I18n.t(:'activerecord.errors.models.synonymy.languages_same') \
			if synonymy.word1.language == synonymy.word2.language
		synonymy.errors.add_to_base I18n.t(:'activerecord.errors.models.synonymy.words_taken') \
			if Synonymy.find_by_word1_id_and_word2_id_and_category_id(synonymy.word1.id, synonymy.word2.id, synonymy.category.id) \
			or Synonymy.find_by_word1_id_and_word2_id_and_category_id(synonymy.word2.id, synonymy.word1.id, synonymy.category.id)
	end
end
