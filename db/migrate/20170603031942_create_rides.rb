class CreateRides < ActiveRecord::Migration
  def change
    create_table :rides do |t|
      t.float :starting_latitude
      t.float :starting_longitude
      t.float :ending_latitude
      t.float :ending_longitude
      t.string :color
      t.integer :cab_id
      t.integer :distance_travelled
      t.integer :cost
      t.string :status, default: 'accepted'

      t.timestamps null: false
    end
    add_foreign_key :rides,
                    :cabs,
                    :on_delete => :cascade,
                    :on_update => :cascade
  end
end
