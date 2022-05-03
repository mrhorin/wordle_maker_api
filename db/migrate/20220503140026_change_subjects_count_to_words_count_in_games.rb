class ChangeSubjectsCountToWordsCountInGames < ActiveRecord::Migration[6.1]
  def change
    rename_column :games, :subjects_count, :words_count
  end
end
