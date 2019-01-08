class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :tasks, dependent: :destroy

  validates_uniqueness_of :auth_token

  before_create :generete_authentication_token!

  def info
    "#{email} - #{created_at} - Token: #{Devise.friendly_token}"
  end

  def generete_authentication_token!
    begin
      self.auth_token = Devise.friendly_token
    end while User.exists?(auth_token: auth_token)
  end
end
