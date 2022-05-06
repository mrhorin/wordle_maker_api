class AddChallengeCountColumnToGames < ActiveRecord::Migration[6.1]
  def change
    add_column :games, :challenge_count, :integer, default: 6
  end
end
