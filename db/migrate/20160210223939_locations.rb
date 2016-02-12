class Locations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :zip_code, null: false
      t.integer :rain_fall, null: false
      t.date :date, null: false
      t.timestamps null: false
    end
    add_index :locations, [:zip_code, :date], :unique => true
  end

end
