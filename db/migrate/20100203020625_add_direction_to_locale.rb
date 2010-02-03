class AddDirectionToLocale < ActiveRecord::Migration
  def self.up
    add_column :locales, :rtl, :boolean, :default => false
  end

  def self.down
    remove_column :locales, :rtl
  end
end
