class Word < ApplicationRecord
  validates :name, word_name: true
  validates :game_id, word_game_id: true, presence: true, uniqueness: { scope: :name, message: "should be unique to name" }
  belongs_to :game, counter_cache: true
  has_many :questions, dependent: :destroy
  has_one :owner, through: :game, foreign_key: "user_id"

  def lang
    Utils::Language.lang game.lang
  end

  def supported_lang?
    keyboards = lang[:keyboards].map do |kbd|
      kbd if name =~ kbd[:regexp]
    end.compact
    keyboards.size == 1
  end
end
