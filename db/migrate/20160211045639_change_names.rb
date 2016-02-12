class ChangeNames < ActiveRecord::Migration
  def change
    rename_column :locations, :rain_fall, :precip
    rename_column :locations, :date, :timestamp
  end
end
