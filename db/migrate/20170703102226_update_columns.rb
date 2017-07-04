class UpdateColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :bids, :payment_made
    
    add_column :listings, :paid, :boolean, default: false
    add_column :listings, :expired, :boolean, default: false
  end
end
