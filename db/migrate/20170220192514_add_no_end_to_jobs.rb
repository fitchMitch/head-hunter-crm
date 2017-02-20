class AddNoEndToJobs < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :no_end, :boolean
  end
end
