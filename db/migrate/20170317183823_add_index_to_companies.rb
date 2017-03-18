class AddIndexToCompanies < ActiveRecord::Migration[5.0]
  def change
    add_index :companies , :company_name
  end
end
