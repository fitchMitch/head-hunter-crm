class ChangeStatusTypeColumnToComactions < ActiveRecord::Migration[5.0]
  def change
    remove_column :comactions, :status, :string
    add_column :comactions,:status, :integer
    remove_column :comactions, :action_type, :string
    add_column :comactions, :action_type, :integer
  end
end
