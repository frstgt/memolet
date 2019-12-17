class AddTitleAndOutlineToPictures < ActiveRecord::Migration[5.1]
  def change
    add_column :pictures, :title, :string
    add_column :pictures, :outline, :text
  end
end
