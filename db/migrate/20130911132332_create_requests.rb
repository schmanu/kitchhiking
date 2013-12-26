class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.text :body
      t.string :subject

      t.belongs_to :hiker
      t.belongs_to :dinner
      t.timestamps
    end
  end
end
