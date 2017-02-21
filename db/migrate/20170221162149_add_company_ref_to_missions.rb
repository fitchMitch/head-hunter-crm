class AddCompanyRefToMissions < ActiveRecord::Migration[5.0]
  def change
    add_reference :missions, :company, foreign_key: true
  end
end
