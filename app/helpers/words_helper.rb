module WordsHelper
	def forms_summary(word)
		word.word_forms.all.map { |form| form.text }.join ' | '
	end
end