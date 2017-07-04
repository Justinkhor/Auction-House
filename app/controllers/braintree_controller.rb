class BraintreeController < ApplicationController
  def new
    @client_token = Braintree::ClientToken.generate
    @listing = Listing.find(params[:listing_id])
  end

  def create
  @listing = Listing.find(params[:listing_id])
  nonce_from_the_client = params[:checkout_form][:payment_method_nonce]
  amount_to_be_paid = @listing.bids.find_by(chosen_bid: true).bidding_price

  result = Braintree::Transaction.sale(
   :amount => amount_to_be_paid,
   :payment_method_nonce => nonce_from_the_client,
   :options => {
      :submit_for_settlement => true
    }
   )
    if result.success?
      @listing.paid = true
      @listing.save
      redirect_to user_path(current_user), notice: "Transaction successful!"
    else
      redirect_to user_path(current_user), notice: "Transaction failed. Please try again."
    end
  end
end
