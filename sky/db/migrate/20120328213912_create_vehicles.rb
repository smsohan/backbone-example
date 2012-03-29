class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.string :vin
      t.string :make
      t.string :model
      t.integer :year
      t.string :color

      t.timestamps
    end
  end
end
