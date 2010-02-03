class Word < ActiveRecord::Base
	belongs_to :locale
	has_many :word_representations, :dependent => :destroy
end
