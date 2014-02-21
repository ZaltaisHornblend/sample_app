class AddUserCvToUsers < ActiveRecord::Migration
  def change
    add_column :users, :user_cv_file_name, :string
    add_column :users, :user_cv_content_type, :string
    add_column :users, :user_cv_file_size, :integer
  end
end
