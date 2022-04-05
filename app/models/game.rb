class Game < ApplicationRecord
  validates :title, presence: true, length: { maximum: 20 }
  validates :desc, length: { maximum: 100 }
  validates :lang, presence: true, length: { is: 2 }, inclusion: { in: ['ja', 'en'] }
  validates :char_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 2, less_than_or_equal_to: 10 }
  validates :user_id, presence: true
  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  has_many :subjects, dependent: :destroy
end
