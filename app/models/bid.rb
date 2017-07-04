class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :listing
  validate :check_chosen_bid, on: :buy_process

  def check_chosen_bid
    return if self.chosen_bid == true
    errors.add(:chosen_bid, "highest bidder!")
  end
end
