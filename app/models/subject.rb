class Subject < ApplicationRecord
  validates :word, subject_word: true
  validates :game_id, presence: true
  belongs_to :game

  def lang
    Utils::Language.lang game.lang
  end
end
