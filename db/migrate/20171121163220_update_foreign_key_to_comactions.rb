class UpdateForeignKeyToComactions < ActiveRecord::Migration[5.0]
  def change
    # remove the old foreign_key
    remove_foreign_key :comactions, :people
    remove_foreign_key :comactions, :missions


    # add the new foreign_key
    add_foreign_key :comactions, :people, on_delete: :cascade
    add_foreign_key :comactions, :missions, on_delete: :cascade
  end
end
