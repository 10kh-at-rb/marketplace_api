class Order < ActiveRecord::Base
  belongs_to :user
  has_many :product_entries
  has_many :products, through: :product_entries
  validates :user, presence: true
  validate :enough_products

  def set_total!
    self.total = product_entries.includes(:product).inject(0) do |sum, entry|
      sum + entry.quantity * entry.product.price
    end
  end

  def enough_products
    product_entries.each do |entry|
      p = entry.product
      if entry.quantity > p.quantity
        errors["#{p.title}"] << "only #{p.quantity} items left"
      end
    end
  end
end
