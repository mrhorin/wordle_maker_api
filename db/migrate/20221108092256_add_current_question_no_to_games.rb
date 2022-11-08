class AddCurrentQuestionNoToGames < ActiveRecord::Migration[6.1]
  def change
    add_column :games, :current_question_no, :integer
  end
end
