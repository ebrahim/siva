class AddIndexToLocales < ActiveRecord::Migration
	def self.up
		add_index :locales, :name, :unique => true
	end

	def self.down
		remove_index :locales, :name
	end
end
