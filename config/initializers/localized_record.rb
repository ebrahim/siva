LocalizedRecord.mode = :tsv
LocalizedRecord.available_locales = Hash[Language.find(:all, :select => 'code, name').map { |l| [l.code, l.name] }]
