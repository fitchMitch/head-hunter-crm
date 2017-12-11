class ModifyActionTypeToComactions < ActiveRecord::Migration[5.0]
  def change
    def up
      change_column :comactions,:status, :integer
      change_column :comactions, :action_type, :integer
    end
    def down
      change_column :comactions, :status, :string
      change_column :comactions, :action_type, :string
    end
  end
end
