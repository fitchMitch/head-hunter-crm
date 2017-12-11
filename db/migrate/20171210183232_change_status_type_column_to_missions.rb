class ChangeStatusTypeColumnToMissions < ActiveRecord::Migration[5.0]
  def change
    remove_column :missions, :status, :string
    add_column :missions,:status, :integer , default: 0
  end
end
