class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_one :profile, dependent: :destroy
  has_many :scores, dependent: :destroy  # 追加
  accepts_nested_attributes_for :profile
  delegate :name, to: :profile, allow_nil: true
  validates :uid, uniqueness: { scope: :provider }, allow_nil: true

  def self.from_omniauth(auth)
    return nil unless auth.info.email_verified

    user = find_by(email: auth.info.email)
    if user
      user.update(provider: auth.provider, uid: auth.uid) if user.provider.blank?
      return user
    end

    find_or_create_by(provider: auth.provider, uid: auth.uid) do |u|
      u.email = auth.info.email
      u.password = Devise.friendly_token[0, 20]
      u.build_profile(name: auth.info.name)
    end
  end
end
