class ChangeStatusTypeColumnToMissions < ActiveRecord::Migration[5.0]
  def change
    remove_column :missions, :status, :string
    add_column :missions, :status, :integer, default: 0
    remove_column :comactions, :status, :string
    add_column :comactions, :status, :integer, default: 0
    remove_column :comactions, :action_type, :string
    add_column :comactions, :action_type, :integer, default: 0  
  end
end
