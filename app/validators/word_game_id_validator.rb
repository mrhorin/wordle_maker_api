class WordGameIdValidator < ActiveModel::EachValidator
  MAX_WORDS_IN_GAME = 3000

  def validate_each(record, attribute, value)
    if record.game.words_count >= MAX_WORDS_IN_GAME
      record.errors.add(attribute, "Game can not have over #{MAX_WORDS_IN_GAME} words.")
    end
  end
end