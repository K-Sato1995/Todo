class Task < ApplicationRecord
  belongs_to :user
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  validates :title, presence: true
  validates :title, length: { in: 2..30 }, allow_blank: true
  validates :description, presence: true
  validates :description, length: { in: 5..100 }, allow_blank: true
  validates :deadline, presence: true
  validates :all_tags, presence: true, category: true

  enum state: { untouched: 0, wip: 1, done: 2 }
  enum priority: { normal: 0, high: 1, urgent: 2 }

  scope :tag_search, ->(*arr) {
    tag_ids = arr.reject { |value| value == '' }
    joins(:taggings).where(taggings: { tag_id: tag_ids }).group('tasks.id').having('count(taggings.id) = ?', tag_ids.length)
  }

  def self.ransackable_scopes(_auth_object = nil)
    [:tag_search]
  end

  def all_tags
    tags.map(&:name).join(',')
  end
end
