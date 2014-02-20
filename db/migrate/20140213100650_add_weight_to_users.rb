class AddWeightToUsers < ActiveRecord::Migration
  def change
    add_column :users, :user_weight, :float
    add_column :users, :ideal_weight, :float
  end
end
