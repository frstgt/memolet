class Note < ApplicationRecord
  belongs_to :user, touch: true
  has_many :memos, dependent: :destroy
  has_many :pictures, dependent: :destroy

  has_many :active_tagships, class_name:  "Tagship",
                              foreign_key: "note_id",
                              dependent:   :destroy
  has_many :tags, through: :active_tagships,  source: :tag

  default_scope -> { order(updated_at: :desc) }

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 100 }
  validates :outline, length: { maximum: 1000 }

  attr_accessor  :tag_list
  def load_tag_list
    tag_names = []
    self.tags.each do |tag|
      tag_names.append(tag.name)
    end
    self.tag_list = tag_names.join(",")
  end
  def save_tag_list
    active_tagships.each do |tagship|
      tag = tagship.tag
      tagship.destroy
      if tag.notes.count == 0
        tag.destroy
      end
    end

    if self.tag_list
      tag_names = self.tag_list.split(",")
      tag_names.each do |tag_name|
        tag = Tag.find_by(name: tag_name)
        unless tag
          tag = Tag.create(name: tag_name)
        end
        active_tagships.create(tag_id: tag.id)
      end
    end
  end

  def picture? # for debug
    false
  end

end
