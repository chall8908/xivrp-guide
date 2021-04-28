class User < ApplicationRecord
  devise(:database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable, :omniauthable,
         :lockable, omniauth_providers: [:discord])

  has_one_attached :avatar

  has_many :events, dependent: :destroy

  def self.from_omniauth(auth)
    # Allow either provider and UID or email with no existing provider
    # info.
    user = where(provider: auth.provider, uid: auth.uid)
      .or(where(email: auth.info.email, provider: nil, uid: nil))
      .first_or_initialize

    user.provider = auth.provider unless user.provider.present?
    user.uid      = auth.uid unless user.uid.present?
    user.email    = auth.info.email unless user.email.present?

    user.password = Devise.friendly_token unless user.encrypted_password?

    user.skip_confirmation! unless user.confirmed?

    unless user.avatar.present?
      url = URI.parse(auth.info.image)
      filename = File.basename(url.path)

      user.avatar.attach(io: URI.open(url), filename: filename)
    end

    user.save! if user.has_changes_to_save?

    user
  end
end
