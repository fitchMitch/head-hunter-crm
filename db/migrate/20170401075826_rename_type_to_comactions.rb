class RenameTypeToComactions < ActiveRecord::Migration[5.0]
  change_table :comactions do |t|
    t.rename :type, :action_type
  end
end
