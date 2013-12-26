class AddDetailsToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :state, :string
  end
end
