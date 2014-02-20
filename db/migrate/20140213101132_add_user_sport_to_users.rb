class AddUserSportToUsers < ActiveRecord::Migration
  def change
    add_column :users, :do_sport, :boolean
    add_column :users, :want_do_sport, :boolean
  end
end
