class Notification < ApplicationRecord
  has_many :notification_shops, dependent: :destroy
  has_many :shops, :through => :notification_shops

  has_many :notification_tag_relations, dependent: :destroy
  has_many :notification_tags, :through => :notification_tag_relations
  accepts_nested_attributes_for :notification_tag_relations, reject_if: :all_blank, allow_destroy: true

  validates :subject, presence: true

  enum status: {
    draft: 0,
    published: 1
  }, _prefix: true

  enum sort: {Terbaru: 0, Terlama: 1, "A-Z" => 2, "Z-A" => 3}

  scope :own_shop, ->(shop_ids) {
    joins(:shops).where(shops: { id: shop_ids } )
  }

  scope :published, ->(){
    where(status: 1)
    .where("published_from <= ?", DateTime.now.in_time_zone('Jakarta').strftime("%Y/%m/%d %H:%M:%S"))
    .where("published_to >= ? or published_to IS NULL", DateTime.now.in_time_zone('Jakarta').strftime("%Y/%m/%d %H:%M:%S"))
  }

  def is_new
    self.published_from >= 2.week.ago.in_time_zone('Jakarta')
  end

  def description
    return if self.body.blank?
    return self.body if self.body.length < 15
    self.body[0..15] + "..."
  end

  class << self
    def sort_condition
      {
        "#{Notification.sorts['Terbaru']}": 'published_from DESC, id DESC',
        "#{Notification.sorts['Terlama']}": 'published_from ASC, id ASC',
        "#{Notification.sorts['A-Z']}": 'subject ASC, id ASC',
        "#{Notification.sorts['Z-A']}": 'subject DESC, id DESC'
      }
    end
  end
end
