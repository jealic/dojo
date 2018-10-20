class Post < ApplicationRecord

  belongs_to :user, counter_cache: true
  has_many :collects, dependent: :destroy
  has_many :replies, dependent: :destroy # post 被刪，其下的 replies 也要被刪，但 user 會在
  # 一個 post 有多個 categories, 一個 category 屬於多個 post
  has_many :post_categoryships # 某 post 被刪，跟這個 post 有關的 post-category 記錄也都會沒有
  has_many :categories, through: :post_categoryships
  
  # 設定 privacy 種類
  enum privacy: {
    public: 1,
    only_friends: 2,
    only_me: 3,
  }

  # 文章是否為草稿
  scope :draft, -> {
    where(draft: true)
  }

  scope :published, -> {
    where(draft: false)
  }
end
