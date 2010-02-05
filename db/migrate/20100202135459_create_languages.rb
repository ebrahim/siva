class CreateLanguages < ActiveRecord::Migration
	def self.up
		create_table :languages do |t|
			t.string :code
			t.string :name

			t.timestamps
		end
		add_index :languages, :code, :unique => true
	end

	def self.down
		drop_table :languages
	end
end
