class Post < ApplicationRecord

  belongs_to :user, counter_cache: true
  has_many :collects, dependent: :destroy
  has_many :collectors, through: :collects, source: :user
  
  has_many :replies, dependent: :destroy # post 被刪，其下的 replies 也要被刪，但 user 會在
  # 一個 post 有多個 categories, 一個 category 屬於多個 post
  has_many :post_categoryships # 某 post 被刪，跟這個 post 有關的 post-category 記錄也都會沒有
  has_many :categories, through: :post_categoryships
  
  mount_uploader :image, ImageUploader


  # 文章是否為草稿
  scope :draft, -> {
    where(draft: true)
  }

  scope :published, -> {
    where(draft: false)
  }

  def is_collected?(user)
    self.collectors.include?(user)    
  end

  # 計算 viewed_count
  def count_views
    self.viewed_count += 1
    self.save
  end
end
