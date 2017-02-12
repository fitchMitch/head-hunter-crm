class AddPersonRefToJobs < ActiveRecord::Migration[5.0]
  def change
    add_reference :jobs, :person, foreign_key: true
  end
end
