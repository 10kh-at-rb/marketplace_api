class Order < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :products
  before_validation :set_total!
  validates :user, :products, presence: true

  def set_total!
    self.total = products.sum(:price)
  end
end
