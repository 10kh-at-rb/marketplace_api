class User < ActiveRecord::Base
  include FriendlyId

  friendly_id :name
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :products
  has_many :orders

  validates :auth_token, uniqueness: true
  validates :name, presence: true,
    format: /\A\w+\z/,
    length: { in: 4..64 },
    uniqueness: { case_sensitive: false }

  before_create :generate_auth_token!
  after_validation :move_friendly_id_error_to_name

  def generate_auth_token!
    begin
      self.auth_token = Devise.friendly_token
    end while self.class.exists?(auth_token: auth_token)
  end

  private

  def move_friendly_id_error_to_name
    errors.add :name, *errors.delete(:friendly_id) if errors[:friendly_id].present?
  end
end
