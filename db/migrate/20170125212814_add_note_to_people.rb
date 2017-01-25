class AddNoteToPeople < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :note, :text
  end
end
