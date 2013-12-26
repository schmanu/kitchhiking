class AddDetailsToDinners < ActiveRecord::Migration
  def change
    add_column :dinners, :active, :bool
  end
end
