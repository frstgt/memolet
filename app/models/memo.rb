class Memo < ApplicationRecord
  belongs_to :note, touch: true

  default_scope -> { order(number: :asc) }

  validates :note_id, presence: true
  validates :content, length: { maximum: 4000 }
  validates :number, presence:true

end
