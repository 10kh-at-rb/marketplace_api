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

  describe "#slug" do
    it "is parameterized title by default" do
      product = Fabricate(:product)
      expect(product.slug).to eq(product.title.parameterize)
    end

    it "is parameterized title + user.name if title is taken" do
      Fabricate(:product, title: "Mechanical Keyboard")
      product = Fabricate(:product, title: "Mechanical Keyboard")
      expect(product.slug).to eq(
        "#{product.title}-by-#{product.user.name}".parameterize
      )
    end
  end
end
