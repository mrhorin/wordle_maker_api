class ChangeSubjectsToWords < ActiveRecord::Migration[6.1]
  def change
    rename_table :subjects, :words
  end
end
