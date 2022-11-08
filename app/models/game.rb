class Game < ApplicationRecord
  validates :title, presence: true, length: { maximum: 100 }
  validates :desc, length: { maximum: 200 }
  validates :lang, presence: true, length: { is: 2 }, inclusion: { in: ['ja', 'en'] }
  validates :char_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 2, less_than_or_equal_to: 10 }
  validates :challenge_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 2, less_than_or_equal_to: 10 }
  validates :user_id, presence: true
  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  has_many :words, dependent: :destroy
  has_many :questions, dependent: :destroy do
    def find_or_create_today
      find_or_create_by(published_on: Date.today) do |q|
        q.word_id = Word.where(game_id: q.game_id).pluck(:id).shuffle.first
        q.no = q.game.current_question_no ? q.game.current_question_no + 1 : 1
        # Should update current_question_no
        q.game.update(current_question_no: q.no)
      end
    end
  end

  def word_list
    words.pluck(:name)
  end
end
