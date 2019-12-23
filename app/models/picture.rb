class Picture < ApplicationRecord
  belongs_to :note, touch: true

  validates :note_id, presence: true
  validates :title, length: { maximum: 100 }
  validates :outline, length: { maximum: 1000 }

  default_scope -> { order(updated_at: :desc) }

  mount_uploader :picture, PictureUploader
  validate  :picture_size

  private

    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end

end
