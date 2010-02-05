class CreateLocales < ActiveRecord::Migration
	def self.up
		create_table :locales do |t|
			t.string :code
			t.string :name

			t.timestamps
		end
		add_index :locales, :code, :unique => true
	end

	def self.down
		drop_table :locales
	end
end
