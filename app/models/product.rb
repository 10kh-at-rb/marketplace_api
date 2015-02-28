class Product < ActiveRecord::Base
  include FriendlyId

  friendly_id :slug_candidates, use: :slugged

  belongs_to :user
  has_many :product_entries
  has_many :orders, through: :product_entries

  validates :user, :title, :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  scope :recent, -> { order(:updated_at) }

  def self.filter_by_title(keyword)
    where("lower(title) LIKE ?", "%#{keyword.downcase}%")
  end

  def self.above_or_equal_to_price(n)
    where("price >= ?", n)
  end

  def self.below_or_equal_to_price(n)
    where("price <= ?", n)
  end

  def self.search(params = {})
    p = params[:product_ids].present? ? where(id: params[:product_ids]) : all
    p = p.filter_by_title(params[:keyword]) if params[:keyword]
    p = p.above_or_equal_to_price(params[:min_price].to_f) if params[:min_price]
    p = p.below_or_equal_to_price(params[:max_price].to_f) if params[:max_price]
    p = p.recent(params[:recent]) if params[:recent].present?
    p
  end

  private

  def slug_candidates
    [:title, [:title, "by", -> { user.name.downcase if user.present? }]]
  end
end
