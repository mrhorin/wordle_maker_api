class WordNameValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    if value.nil? || value.empty?
      record.errors.add(attribute, "#{attribute} column is required.")
    elsif !record.supported_lang?
      record.errors.add(attribute, "#{value} doesn't match any keyboards in #{record.game.lang}.")
    elsif value.length != record.game.char_count
      record.errors.add(attribute, "#{value} must be #{record.game.char_count} letter.")
    end
  end

end