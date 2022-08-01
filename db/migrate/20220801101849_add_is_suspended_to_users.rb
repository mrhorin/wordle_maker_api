class AddIsSuspendedToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :is_suspended, :boolean, default: false
  end
end
