class CreateDinners < ActiveRecord::Migration
  def change
    create_table :dinners do |t|
      t.string :title
      t.text :description

      t.belongs_to :hiker
      t.datetime :dinner_start_date
      t.datetime :dinner_end_date
      t.timestamps
    end
  end
end
