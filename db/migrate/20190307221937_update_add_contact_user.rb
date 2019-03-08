class UpdateAddContactUser < ActiveRecord::Migration[5.0]
  def change
    add_reference :companies, :company_representative, index: true, null: true
    add_foreign_key :companies, :people, column: :company_representative_id
  end
end
