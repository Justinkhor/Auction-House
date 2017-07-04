class Listing < ApplicationRecord
  has_many :images, :dependent => :destroy
  has_many :bids, :dependent => :destroy
  belongs_to :user
  searchkick match: :word_start, searchable: [:state, :city, :address, :name]
end
