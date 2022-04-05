class AddDescToGames < ActiveRecord::Migration[6.1]
  def change
    add_column :games, :desc, :string, limit: 100
  end
end
