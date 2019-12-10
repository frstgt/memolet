class Site < ApplicationRecord

  validates :name,  presence: true

  MODE_LOCAL = 0
  MODE_SITE  = 1
  MODE_WEB   = 2
  validates :mode,  presence: true
  def can_edit?(user)
    user && user.admin_en? && user.admin?
  end

end
