LocalizedRecord.mode = :tsv
begin
	raise Exception.new if Language.all.blank?
	LocalizedRecord.available_locales = Hash[Language.find(:all, :select => 'code, name').map { |l| [l.code, l.name] }]
rescue Exception
	LocalizedRecord.available_locales = { 'fa' => 'فارسی', 'en' => 'English' }
end
