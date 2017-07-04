class CreateListings < ActiveRecord::Migration[5.0]
  def change
    create_table :listings do |t|
      t.string :name, :address, :city, :state, :house_type
      t.integer :num_of_rooms, :price
      t.datetime :expiration
      t.references :user
      t.timestamps
    end
  end
end
