class Subject < ApplicationRecord
  validates :word, subject_word: true
  validates :game_id, subject_game_id: true, presence: true, uniqueness: { scope: :word, message: "should be unique to word" }
  belongs_to :game, counter_cache: true

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
