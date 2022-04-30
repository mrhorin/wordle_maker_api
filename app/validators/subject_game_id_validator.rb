class SubjectGameIdValidator < ActiveModel::EachValidator
  MAX_SUBJECTS_IN_GAME = 3000

  def validate_each(record, attribute, value)
    if record.game.subjects_count >= MAX_SUBJECTS_IN_GAME
      record.errors.add(attribute, "Game can not have over #{MAX_SUBJECTS_IN_GAME} subjects.")
    end
  end
end