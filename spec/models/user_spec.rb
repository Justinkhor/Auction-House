require 'rails_helper'

RSpec.describe User, type: :model do
  context "validations" do

    context "presence" do
      it { should validate_presence_of :first_name }
      it { should validate_presence_of :last_name }
      it { should validate_presence_of :username }
      it { should validate_presence_of :email }
      it { should validate_presence_of :password }
    end

    context "uniqueness" do
      it { should validate_uniqueness_of :email }
      it { should validate_uniqueness_of :username }
    end

    it { should have_secure_password }
  end

    it { should have_many(:listings) }
    it { should have_many(:bids) }

    it "should be user" do
    user = User.new
    user.set_default_role
    expect(user.role).to eq("user")
  end
end
