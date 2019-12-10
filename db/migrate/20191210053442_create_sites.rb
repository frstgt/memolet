class CreateSites < ActiveRecord::Migration[5.1]
  def change
    create_table :sites do |t|
      t.string :name, default: "Memolet"
      t.integer :mode, default: 0

      t.timestamps
    end
  end
end
