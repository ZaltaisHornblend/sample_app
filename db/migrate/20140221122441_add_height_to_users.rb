class AddHeightToUsers < ActiveRecord::Migration
  def change
    add_column :users, :user_height, :integer
  end
end
