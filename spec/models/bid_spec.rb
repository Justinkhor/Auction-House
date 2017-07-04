require 'rails_helper'

RSpec.describe Bid, type: :model do
  context "validations" do

    context "presence" do
      it { should validate_presence_of :bidding_price }
    end
  end

    it { should belong_to(:listing) }
    it { should belong_to(:user) }

    it "should check chosen bid" do
      bid = Bid.new
      bid.check_chosen_bid
      expect(bid.chosen_bid).to eq(true)
    end
end
