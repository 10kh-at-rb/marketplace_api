require 'rails_helper'

RSpec.describe Product do
  subject { Fabricate.build(:product) }

  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:price) }
  it { is_expected.to respond_to(:for_sale) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_and_belong_to_many(:orders) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:price) }
  it { is_expected.to validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_presence_of :user }

  context "when deleted" do
    specify "associated orders do not get deleted" do
      product = Fabricate(:product_with_orders)
      orders = product.orders
      product.destroy
      orders.each do |order|
        expect(Order.find(order.id)).not_to raise_error
      end
    end
  end

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

  describe ".filter_by_title" do
    it "returns products with the specified title" do
      p1 = Fabricate(:product, title: "A plasma TV")
      p2 = Fabricate(:product, title: "Fastest Laptop")
      p3 = Fabricate(:product, title: "CD player")
      p4 = Fabricate(:product, title: "LCD TV")
      expect(Product.filter_by_title("TV")).to contain_exactly(p1, p4)
    end
  end

  describe "numeric comparison filters" do
    let(:p1) { Fabricate(:product, price: 100) }
    let(:p2) { Fabricate(:product, price: 50)  }
    let(:p3) { Fabricate(:product, price: 150) }
    let(:p4) { Fabricate(:product, price: 99)  }

    specify ".above_or_equal_to_price" do
      expect(Product.above_or_equal_to_price(100)).to contain_exactly(p1, p3)
    end

    specify ".below_or_equal_to_price" do
      expect(Product.below_or_equal_to_price(99)).to contain_exactly(p2, p4)
    end
  end

  describe ".recent" do
    it "returns the most updated records" do
      p1 = Fabricate(:product, price: 100)
      p2 = Fabricate(:product, price: 50)
      p3 = Fabricate(:product, price: 150)
      p4 = Fabricate(:product, price: 99)
      p2.touch
      p3.touch
      expect(Product.recent).to match_array([p3, p2, p4, p1])
    end
  end

  describe ".search" do
    let(:p1) { Fabricate(:product, price: 100, title: "Plasma tv")         }
    let(:p2) { Fabricate(:product, price: 50,  title: "Videogame console") }
    let(:p3) { Fabricate(:product, price: 150, title: "MP3")               }
    let(:p4) { Fabricate(:product, price: 99,  title: "Laptop")            }

    context "valid conditions" do
      it "returns the found products" do
        params = { keyword: "tv", min_price: 50, max_price: 150 }
        expect(Product.search(params)).to match_array([p1]) 
      end
    end

    context "invalid conditions" do
      it "returns an empty array" do
        params = { keyword: "videogame", min_price: 100 }
        expect(Product.search(params)).to be_empty
      end
    end

    context "no conditions" do
      it "returns all the products" do
        expect(Product.search({})).to contain_exactly(p1, p2, p3, p4)
      end
    end

    context "search by product_ids" do
      it "returns the products with the specified ids" do
        params = { product_ids: [p1.id, p2.id]}
        expect(Product.search(params)).to contain_exactly(p1, p2)
      end
    end
  end
end
