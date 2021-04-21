class User < ApplicationRecord
  devise(:database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable, :omniauthable,
         :lockable, omniauth_providers: [:discord])

  has_one_attached :avatar

  has_many :events, dependent: :destroy

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token

      url = URI.parse(auth.info.image)
      filename = File.basename(url.path)

      user.avatar.attach(io: URI.open(url), filename: filename)

      user.skip_confirmation!
    end
  end
end
