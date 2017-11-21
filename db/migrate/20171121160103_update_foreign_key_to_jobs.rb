class UpdateForeignKeyToJobs < ActiveRecord::Migration[5.0]
  def change
    # remove the old foreign_key
    remove_foreign_key :jobs, :people

    # add the new foreign_key
    add_foreign_key :jobs, :people, on_delete: :cascade
  end
end
