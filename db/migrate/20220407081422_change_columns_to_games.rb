class ChangeColumnsToGames < ActiveRecord::Migration[6.1]
  def up
    change_column :games, :title, :string, limit: 100
    change_column :games, :desc, :string, limit: 200
  end

  def down
    change_column :games, :title, :string, limit: 20
    change_column :games, :desc, :string, limit: 100
  end
end
