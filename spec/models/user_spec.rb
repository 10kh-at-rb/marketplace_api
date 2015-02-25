require 'rails_helper' 

RSpec.describe User do
  subject { Fabricate.build(:user) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_least(4).is_at_most(64) }
  it { is_expected.to validate_uniqueness_of(:auth_token) }
  it { is_expected.to validate_confirmation_of(:password) }
  it { is_expected.to allow_value("user@example.io").for(:email) }
  it { is_expected.to have_many(:products) }
  it { is_expected.to have_many(:orders) }

  describe "#generate_auth_token!" do
    it "generates a unique token" do
      existing_user = Fabricate(:user, auth_token: "existing_token")
      user = Fabricate(:user)
      user.generate_auth_token!
      expect(user.auth_token).not_to eq(existing_user.auth_token)
    end

    it "is used in a before_create callback" do
      expect(Fabricate(:user).auth_token).not_to be_nil
    end
  end

  context "when destroyed" do
    specify "all associated products get destroyed" do
      user = Fabricate(:user_with_products)
      products = user.products
      user.destroy
      products.each do |product|
        expect { Product.find(product.id) }.to raise_error
      end
    end

    specify "all associated orders get destroyed" do
      user = Fabricate(:user_with_orders)
      orders = user.orders
      user.destroy
      orders.each do |order|
        expect { Order.find(order.id) }.to raise_error
      end
    end
  end

  describe "#name" do
    it "is unique regardless of case" do
      Fabricate(:user, name: 'user')
      expect(Fabricate.build(:user, name: 'user')).to be_invalid
      expect(Fabricate.build(:user, name: 'User')).to be_invalid
    end

    it "does not contain special characters or spaces" do
      ["something@something.com", "another'quirk", ".boundary_case.",
       "another..case", "another/random\\test", "yet]another",
       ".Ὁμηρος", "I have spaces"].each do |name|
         expect(Fabricate.build(:user, name: name)).to be_invalid
       end
    end

    it "is not one of the reserved names" do
      user = Fabricate.build(:user, name: "admin")
      expect(user).to be_invalid
      expect(user.errors[:name]).to include("is reserved")
    end
  end
end
