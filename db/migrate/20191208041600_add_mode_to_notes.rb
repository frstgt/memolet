class AddModeToNotes < ActiveRecord::Migration[5.1]
  def change
    add_column :notes, :mode, :integer, default: 0
  end
end
