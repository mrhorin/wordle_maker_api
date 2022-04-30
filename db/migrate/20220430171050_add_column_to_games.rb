class AddColumnToGames < ActiveRecord::Migration[6.1]
  def change
    add_column :games, :subjects_count, :integer, default: 0
  end
end
