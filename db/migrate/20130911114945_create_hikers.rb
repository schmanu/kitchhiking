class CreateHikers < ActiveRecord::Migration
  def change
    create_table :hikers do |t|
      t.string :first_name
      t.string :last_name
      t.string :username
      t.text :about
      t.date :birth

      t.timestamps
    end
  end
end
