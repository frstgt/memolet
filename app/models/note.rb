class Note < ApplicationRecord
  belongs_to :user, touch: true
  has_many :memos, dependent: :destroy

  default_scope -> { order(updated_at: :desc) }

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 100 }
  validates :outline, length: { maximum: 1000 }

  def picture? # for debug
    false
  end

end
