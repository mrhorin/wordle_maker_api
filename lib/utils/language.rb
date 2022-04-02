class Utils::Language

  def self.langs
    {
      en: {
        keyboards: [
          { name: 'alphabet', regexp: /^[A-Za-z]+$/ }
        ]
      }
    }
  end

  def self.lang lang
    langs[lang.to_sym]
  end
end