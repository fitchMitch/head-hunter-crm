class AddColumnToPeople < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :cv_content, :text
  end
end
