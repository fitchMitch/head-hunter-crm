class DropTagsTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :people_tags
    drop_table :tags
  end
end
