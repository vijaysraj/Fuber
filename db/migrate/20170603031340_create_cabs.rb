class CreateCabs < ActiveRecord::Migration
  def change
    create_table :cabs do |t|
      t.string :address
      t.float :latitude
      t.float :longitude
      t.string :color, default: 'white'
      t.boolean :availability, default: true

      t.timestamps null: false
    end
  end
end
