class AddDirectionToLanguage < ActiveRecord::Migration
	def self.up
		add_column :languages, :rtl, :boolean, { :default => false, :null => false }
	end

	def self.down
		remove_column :languages, :rtl
	end
end
