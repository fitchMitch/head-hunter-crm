class RemoveColumnToPeople < ActiveRecord::Migration[5.0]
  def change
    remove_column :people, :cell_phone_number, :string
    add_column :people, :approx_age, :integer
  end
end
