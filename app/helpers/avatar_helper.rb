module AvatarHelper
  def avatar_url_for(user)
    user.profile&.avatar&.attached? ? user.profile.avatar : nil
  end
end
