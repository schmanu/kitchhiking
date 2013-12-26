class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :rating
      t.string :subject
      t.text :comment

      t.belongs_to :writer
      t.belongs_to :dinner

      t.timestamps
    end
  end
end
