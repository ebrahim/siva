class InsertDefaultLanguages < ActiveRecord::Migration
	def self.up
		Language.create(:code => 'fa', :name => "en\tPersian\tfa\tفارسی", :rtl => true)
		Language.create(:code => 'en', :name => "en\tEnglish\tfa\tانگلیسی", :rtl => false)
	end

	def self.down
	end
end
