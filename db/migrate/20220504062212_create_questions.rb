class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.integer :game_id
      t.integer :word_id
      t.date :published_on

      t.timestamps
    end

    add_index :questions, [:game_id, :published_on], unique: true
  end
end
