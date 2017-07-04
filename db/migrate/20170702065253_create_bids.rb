class CreateBids < ActiveRecord::Migration[5.0]
  def change
    create_table :bids do |t|
      t.references :user
      t.references :listing
      t.integer :bidding_price
      t.boolean :chosen_bid, default: true
      t.boolean :payment_made, default: false
      t.timestamps
    end

    add_column :listings, :sold, :boolean, default: false
  end
end
