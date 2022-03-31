class RemoveColumnsFromUsers < ActiveRecord::Migration[6.1]
  def change
    ## Recoverable
    remove_column :users, :reset_password_token, :string
    remove_column :users, :reset_password_sent_at, :datetime
    remove_column :users, :allow_password_change, :boolean
    ## Rememberable
    remove_column :users, :remember_created_at, :datetime
    ## Trackable
    remove_column :users, :sign_in_count, :integer
    remove_column :users, :current_sign_in_at, :datetime
    remove_column :users, :last_sign_in_at, :datetime
    remove_column :users, :current_sign_in_ip, :integer
    remove_column :users, :last_sign_in_ip, :integer
  end
end
