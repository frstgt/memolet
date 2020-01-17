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

  mount_uploader :picture, PictureUploader
  validate  :picture_size

  MODE_LOCAL = 0
  MODE_SITE  = 1
  MODE_WEB   = 2
  validates :mode, presence: true
  def can_show?(user)
    c1 = (self.user == user) # mine
    c3 = (user && self.mode == MODE_SITE) # login user
    c4 = (self.mode == MODE_WEB) # outsider
    c5 = (user && user.admin_en? && user.admin?)
    c1 || c3 || c4 || c5
  end
  def can_edit?(user)
    c1 = self.user == user
    c5 = (user && user.admin_en? && user.admin?)
    c1 || c5
  end

  attr_accessor  :tag_list
  def load_tag_list
    tag_names = []
    self.tags.each do |tag|
      tag_names.append(tag.name)
    end
    self.tag_list = tag_names.join(", ")
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
        add_tag(tag_name.strip)
      end
    end
  end
  def add_tag(tag_name)
    tag = Tag.find_by(name: tag_name)
    if tag
      tagship = active_tagships.find_by(tag_id: tag.id)
      unless tagship
        active_tagships.create(tag_id: tag.id)
      end
    else
      tag = Tag.create(name: tag_name)
      if tag
        active_tagships.create(tag_id: tag.id)
      end
    end
  end

  private

    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end

end
