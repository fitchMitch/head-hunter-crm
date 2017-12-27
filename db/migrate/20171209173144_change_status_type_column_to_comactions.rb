class ChangeStatusTypeColumnToComactions < ActiveRecord::Migration[5.0]
  def change
    remove_column :comactions, :status, :string
    add_column :comactions,:status, :integer
    remove_column :comactions, :action_type, :string, default: 0
    add_column :comactions, :action_type, :integer, default: 0
  end
end
