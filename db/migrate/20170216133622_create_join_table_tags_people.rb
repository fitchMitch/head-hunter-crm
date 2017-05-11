class CreateJoinTableTagsPeople < ActiveRecord::Migration[5.0]
  def change
    create_join_table :tags, :people do |t|
       t.index [:tag_id, :person_id]
       t.index [:person_id, :tag_id]
    end
  end
end
