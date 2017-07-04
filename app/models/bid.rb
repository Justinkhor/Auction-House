class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :listing
  validates :bidding_price, presence: true
  validate :check_chosen_bid

  def check_chosen_bid
    return if self.chosen_bid == true
    errors.add(:chosen_bid, "highest bidder!")
  end
end
