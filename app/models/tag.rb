class Tag < ApplicationRecord

  has_many :passive_tagships, class_name:  "Tagship",
                              foreign_key: "tag_id",
                              dependent:   :destroy
  has_many :notes, through: :passive_tagships,  source: :note

  validates :name, presence: true

  def user_notes(user)
    note_ids = "SELECT note_id FROM tagships WHERE user_id = :user_id and tag_id = :tag_id"
    Note.where("id IN (#{note_ids})", user_id: user.id, tag_id: id)
  end

end
