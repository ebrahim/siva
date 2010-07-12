class CreateDomains < ActiveRecord::Migration
	def self.up
		create_table :domains do |t|
			t.string :name
			t.integer :parent_id
			t.integer :lft
			t.integer :rgt

			t.timestamps
		end
		add_index :domains, :name
	end

	def self.down
		drop_table :domains
	end
end
