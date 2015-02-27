class Order < ActiveRecord::Base
  belongs_to :user
  has_many :product_entries
  has_many :products, through: :product_entries
  before_validation :set_total!
  validates :user, presence: true

  def set_total!
    self.total = products.sum(:price)
  end
end
