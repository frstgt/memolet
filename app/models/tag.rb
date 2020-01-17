class Tag < ApplicationRecord

  has_many :passive_tagships, class_name:  "Tagship",
                              foreign_key: "tag_id",
                              dependent:   :destroy
  has_many :notes, through: :passive_tagships,  source: :note

  # should be enable to include - _
  # should not be enable to include \s & | () !
  VALID_TAG_REGEX = /[^\s\+\/\*\%\^\&\|\~\<\=\>\"\'\`\;\:\[\]\{\}\(\)\!\?\@\#\$\,\.\\]+/
  validates :name, presence: true,
                    length: { maximum: 100 },
                    format: { with: VALID_TAG_REGEX },
                    uniqueness: true

end
