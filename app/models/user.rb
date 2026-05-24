class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2, :line ]

  has_one :profile, dependent: :destroy
  has_many :scores, dependent: :destroy  # 追加
  accepts_nested_attributes_for :profile
  delegate :name, to: :profile, allow_nil: true
  validates :uid, uniqueness: { scope: :provider }, allow_nil: true

  def self.from_omniauth(auth)
    return nil if auth.provider == "google_oauth2" && !auth.info.email_verified
    return nil if auth.info.email.blank?

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
  def self.create_from_omniauth_with_email(auth, email)
    return nil if email.blank?
    return nil if exists?(email: email)

    create do |u|
      u.provider = auth.provider
      u.uid = auth.uid
      u.email = email
      u.password = Devise.friendly_token[0, 20]
      u.build_profile(name: auth.info.name.presence || "ユーザー")
    end
  end
end
