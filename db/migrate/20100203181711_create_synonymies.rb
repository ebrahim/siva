class CreateSynonymies < ActiveRecord::Migration
	def self.up
		create_table :synonymies do |t|
			t.references :domain
			t.integer :word1_id
			t.integer :word2_id

			t.timestamps
		end
	end

	def self.down
		drop_table :synonymies
	end
end
