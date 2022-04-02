class Utils::Language

  def self.langs
    {
      en: {
        keyboards: [
          { name: 'alphabet', regexp: /^[A-Za-z]+$/ }
        ]
      },
      ja: {
        keyboards: [
          { name: 'kanakana', regexp: /^[\p{katakana}　ー－&&[^ -~｡-ﾟ]]+$/ }
        ]
      }
    }
  end

  def self.lang lang
    langs[lang.to_sym]
  end

end