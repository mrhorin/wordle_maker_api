class AddIsSuspendedToGames < ActiveRecord::Migration[6.1]
  def change
    add_column :games, :is_suspended, :boolean, default: false
  end
end
