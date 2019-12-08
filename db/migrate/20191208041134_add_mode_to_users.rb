class AddModeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :mode, :integer, default: 0
  end
end
