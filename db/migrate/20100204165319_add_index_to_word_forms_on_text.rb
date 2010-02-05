class AddIndexToWordFormsOnText < ActiveRecord::Migration
	def self.up
		add_index :word_forms, :text
	end

	def self.down
		remove_index :word_forms, :text
	end
end
