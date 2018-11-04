class Post < ApplicationRecord

  belongs_to :user, counter_cache: true
  has_many :collects, dependent: :destroy
  has_many :collectors, through: :collects, source: :user
  
  has_many :replies, dependent: :destroy # post 被刪，其下的 replies 也要被刪，但 user 會在
  # 一個 post 有多個 categories, 一個 category 屬於多個 post
  has_many :post_categoryships, dependent: :destroy # 某 post 被刪，跟這個 post 有關的 post-category 記錄也都會沒有
  has_many :categories, through: :post_categoryships
  
  mount_uploader :image, ImageUploader
  validates_presence_of [:content, :title]


  # 文章是否為草稿
  scope :draft, -> {
    where(draft: true)
  }

  scope :published, -> {
    where(draft: false)
  }

  # 沒有這個設定沒辦法寫入，privacy 會是 0
  enum privacy: {
    all_user:     1, # 公開
    only_friend:  2, # 好友限定
    only_me:      3, # 僅限自己

  # 1,2,3 只是順序，不能被 pass 進 tables
  }

  def is_collected?(user)
    self.collectors.include?(user)    
  end

  # 計算 viewed_count
  def count_views
    self.viewed_count += 1
    self.save
  end

  # 沒有 filter 到的感覺
  def self.access_posts(user)
    Post.where(privacy: "only_friend", user: user.all_friends).or( Post.where(privacy: "all_user")).or(Post.where(privacy: "only_me", user: user))
  end

  def be_viewed_by?(user) 
  # self 用在 post 上，只要符合其中一個條件就可以看到
  # 在首頁，user 以 current_user 為先決判斷條件；
  # 自己可以全部 user 的公開 post，加上我自己的，
  # 再加上和我是朋友關係的 user 的 朋友可見 post 就其全了。
    if self.user == user
      return true
    elsif self.draft && self.user == user
      return true
    elsif self.privacy == 'only_me' && self.user == user
      return true
    elsif self.privacy == 'all_user' && !self.draft
      return true
    elsif self.privacy == 'only_friend'
      self.user.friends.where('friendships.status = ?', 'true').include?(user)
      return true
    else
      return false
    end
  end
end
