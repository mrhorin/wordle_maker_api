class AddNoToQuestions < ActiveRecord::Migration[6.1]
  def change
    add_column :questions, :no, :integer, null: false
    add_index :questions, [:game_id, :no], unique: true
  end
end
