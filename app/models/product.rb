class Product < ActiveRecord::Base
  belongs_to :user

  validates :user, :title, :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
