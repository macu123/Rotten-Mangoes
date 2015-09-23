class AddAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :if_admin, :boolean
  end
end
