class Question < ApplicationRecord
  validates :game_id, presence: true, uniqueness: { scope: :published_on, message: "should be unique to published_on" }
  validates :published_on, presence: true
  validates :word_id, presence: true
  belongs_to :game
  belongs_to :word
end
