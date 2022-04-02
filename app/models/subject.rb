class Subject < ApplicationRecord
  validates :word, subject_word: true
  validates :game_id, presence: true
  belongs_to :game

  def lang
    Utils::Language.lang game.lang
  end

  def supported_lang?
    keyboards = lang[:keyboards].map do |kbd|
      kbd if word =~ kbd[:regexp]
    end.compact
    keyboards.size == 1
  end
end
