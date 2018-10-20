class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :replies, dependent: :destroy
  has_many :collects, dependent: :destroy
  # 一個 user 收藏多筆 post，同一個 post 可以被不同的 user 收藏
  has_many :collected_posts, through: :collects, source: :post
  has_many :friendships #自關聯，有多個朋友
  has_many :friends, through: :friendships
  # 自關聯，要先反轉才可以反過來使用, 指定那個 table: class_name, 本來的索引是 friend_id
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id"
  has_many :friender, through: :inverse_friendships, source: :user
  #friender 是加別人當朋友的人

  def admin?
    self.role == "admin"
  end
end
