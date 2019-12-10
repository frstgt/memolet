class AddAdminEnToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :admin_en, :boolean, default: false
  end
end
