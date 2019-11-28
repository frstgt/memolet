class User < ApplicationRecord

  validates :name, presence: true,
                    length: { minimum: 8, maximum: 64 },
                    uniqueness: true

  has_secure_password
  VALID_PASSWORD_REGEX = /(?=.*(\d+.*){4,})(?=.*([a-z]+.*){4,})(?=.*([A-Z]+.*){4,}).*([\-\+\/\*\%\^\&\|\~\<\=\>\"\'\`\;\:\[\]\{\}\(\)\!\?\@\#\$\,\.\_\\]+.*){4,}/
  validates :password, presence: true,
                       length: { minimum: 16, maximum: 64 },
                       format: { with: VALID_PASSWORD_REGEX },
                       allow_nil: true

  def picture? # for debug
    false
  end

end
