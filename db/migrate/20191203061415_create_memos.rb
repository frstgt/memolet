class CreateMemos < ActiveRecord::Migration[5.1]
  def change
    create_table :memos do |t|
      t.text :content
      t.integer :number
      t.references :note, foreign_key: true

      t.timestamps
    end
    add_index :memos, [:note_id, :number]
  end
end
