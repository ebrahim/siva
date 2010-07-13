module LocalizedRecord
  mattr_accessor :mode, :available_locales
  
  self.mode = :tsv
  self.available_locales = [ I18n.default_locale.to_s, 'es' ]
  
  def available_modes
    [ :tsv ] # TODO ... , :tmx ]
  end

  def self.localized?(value, mode = nil)
    mode ||= LocalizedRecord.mode
    
    case mode
    when :tsv
      value =~ /\t/
      
    else
      raise InvalidTranslationMode.new(mode)
    end
  end

  def self.s_to_translations(value, mode = nil)
    mode ||= LocalizedRecord.mode

    case mode
    when :tsv
      values = value.split("\t")
      values << "" if values.count % 2 > 0
      translations = Hash[*values]
      
    else
      raise InvalidTranslationMode.new(mode)
    end
  end
  
  def self.translations_to_s(translations, mode = nil)
    mode ||= LocalizedRecord.mode

    case mode
    when :tsv
      translations.inject('') { |output, (locale, value)| "#{output}#{output.blank? ? "" : "\t"}#{locale}\t#{value}" }
      
    when :tmx
      # TODO

    else
      raise InvalidTranslationMode.new(mode)
    end
  end
end
