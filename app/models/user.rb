class User < ApplicationRecord
  has_many :notes, dependent: :destroy
  
  validates :name, presence: true,
                    length: { minimum: 8, maximum: 64 },
                    uniqueness: true

  default_scope -> { order(updated_at: :desc) }

  has_secure_password
  VALID_PASSWORD_REGEX = /(?=.*(\d+.*){4,})(?=.*([a-z]+.*){4,})(?=.*([A-Z]+.*){4,}).*([\-\+\/\*\%\^\&\|\~\<\=\>\"\'\`\;\:\[\]\{\}\(\)\!\?\@\#\$\,\.\_\\]+.*){4,}/
  validates :password, presence: true,
                       length: { minimum: 16, maximum: 64 },
                       format: { with: VALID_PASSWORD_REGEX },
                       allow_nil: true

  MODE_LOCAL = 0
  MODE_SITE  = 1
  MODE_WEB   = 2
  validates :mode, presence: true
  def can_show?(user)
    c1 = (self == user) # mine
    c3 = (user && self.mode == MODE_SITE) # login user
    c4 = (self.mode == MODE_WEB) # outsider
    # c5 = (user && user.admin?)
    c1 || c3 || c4 # || c5
  end
  def can_edit?(user)
    c1 = self == user
    # c5 = (user && user.admin?)
    c1 # || c5
  end

  def picture? # for debug
    false
  end

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

end
