class AddBasicColsToCandidates < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :whished_job_title, :string
    add_column :people, :experience_years, :integer
    add_column :people, :whished_salary, :float
  end
end
