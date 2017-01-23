class AddBasicColsToPeople < ActiveRecord::Migration[5.0]
  def change
    add_column :people, :is_jj_hired, :boolean
    add_column :people, :is_client, :boolean
  end
end
