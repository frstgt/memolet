class User < ApplicationRecord

  validates :name, presence: true,
                    length: { minimum: 8, maximum: 64 },
                    uniqueness: true

  has_secure_password
  VALID_PASSWORD_REGEX = /(?=.*(\d+.*){3,})(?=.*([a-z]+.*){3,})(?=.*([A-Z]+.*){3,}).*([\-\+\/\*\%\^\&\|\~\<\=\>\"\'\`\;\:\[\]\{\}\(\)\!\?\@\#\$\,\.\_\\]+.*){3,}/
  validates :password, presence: true,
                       length: { minimum: 16, maximum: 64 },
                       format: { with: VALID_PASSWORD_REGEX },
                       allow_nil: true

end
