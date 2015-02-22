require 'rails_helper'

RSpec.describe Product do
  subject { Fabricate.build(:product) }

  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:price) }
  it { is_expected.to respond_to(:for_sale) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:price) }
  it { is_expected.to validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_presence_of :user }

  it "is not for sale by default" do
    expect(subject).not_to be_for_sale
  end
end
