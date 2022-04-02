class Utils::Language

  def self.langs
    {
      en: {
        name: 'English',
        keyboards: [
          { name: 'alphabet', regexp: /^[A-Za-z]+$/ }
        ]
      },
      ja: {
        name: 'Japanese',
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