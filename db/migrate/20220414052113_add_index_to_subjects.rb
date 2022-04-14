class AddIndexToSubjects < ActiveRecord::Migration[6.1]
  def change
    add_index :subjects, [:game_id, :word], unique: true
  end
end
