class Product < ActiveRecord::Base
  include FriendlyId

  friendly_id :slug_candidates, use: :slugged

  belongs_to :user

  validates :user, :title, :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  private

  def slug_candidates
    [:title, [:title, "by", -> { user.name.downcase if user.present? }]]
  end
end
