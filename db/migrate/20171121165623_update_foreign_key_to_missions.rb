class UpdateForeignKeyToMissions < ActiveRecord::Migration[5.0]
  def change
    # remove the old foreign_key
    remove_foreign_key :missions, :people


    # add the new foreign_key
    add_foreign_key :missions, :people, on_delete: :cascade
  end
end
