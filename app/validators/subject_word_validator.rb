class SubjectWordValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    if value.empty? || value.length != record.game.char_count
      record.errors.add(attribute, "word column must be #{record.game.char_count} letter.")
    end
  end

end