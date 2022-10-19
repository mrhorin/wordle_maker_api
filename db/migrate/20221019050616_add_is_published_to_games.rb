class AddIsPublishedToGames < ActiveRecord::Migration[6.1]
  def change
    add_column :games, :is_published, :boolean, default: false
  end
end
