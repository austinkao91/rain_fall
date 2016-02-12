class ChangeToFloat < ActiveRecord::Migration
  def change
    remove_column :locations, :zip_code, :integer
    add_column :locations, :zip_code, :string
    remove_column :locations, :precip, :integer
    add_column :locations, :precip, :string
  end
end
