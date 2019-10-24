class User < ApplicationRecord
  extend Enumerize

  has_many :blogs
  has_many :comments

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :omniauthable, omniauth_providers: %i(google_oauth2)
  validates :name, presence: true
  validates :email, presence: true

  enumerize :sex, in: [:male, :female, :other, :rather_not_say]

  mount_uploader :avatar, AvatarUploader

  protected

  def self.find_for_google(auth)
    user = User.find_by(email: auth.info.email)

    unless user
      user = User.create(name: auth.info.name,
                         email: auth.info.email,
                         provider: auth.provider,
                         uid: auth.uid,
                         token: auth.credentials.token)
    end
    user
  end
end
