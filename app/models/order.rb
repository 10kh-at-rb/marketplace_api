class Order < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :products
  validates :total, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :user, presence: true
end
