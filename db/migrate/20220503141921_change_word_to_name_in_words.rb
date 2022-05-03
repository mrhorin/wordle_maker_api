class ChangeWordToNameInWords < ActiveRecord::Migration[6.1]
  def change
    rename_column :words, :word, :name
  end
end
