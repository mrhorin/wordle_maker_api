class CreateGames < ActiveRecord::Migration[6.1]
  def change
    create_table :games do |t|
      t.string :title, null: false, limit: 20
      t.string :lang, null: false, limit: 2
      t.integer :char_count, null: false, default: 5
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
