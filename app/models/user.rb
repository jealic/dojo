class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_create :generate_authentication_token

  has_many :posts
  has_many :replies, dependent: :destroy
  has_many :collects, dependent: :destroy
  # 一個 user 收藏多筆 post，同一個 post 可以被不同的 user 收藏
  has_many :collected_posts, through: :collects, source: :post

  # 自己發出並被同意的邀請
  has_many :friendships, -> {where status: true}, dependent: :destroy
  has_many :friends, through: :friendships
  # 對方發出並已同意的邀請
  has_many :inverse_friendships, -> {where status: true}, class_name: "Friendship", foreign_key: "friend_id"
  has_many :inverse_friends, through: :inverse_friendships, source: :user
  # 自己發出並尚未同意的邀請
  has_many :request_friendships, -> {where status: false}, class_name: "Friendship", dependent: :destroy
  has_many :request_friends, through: :request_friendships, source: :friend
  # 對方發出並尚未同意的邀請
  has_many :inverse_request_friendships, -> {where status: false}, class_name: "Friendship", foreign_key: "friend_id", dependent: :destroy
  has_many :inverse_request_friends, through: :inverse_request_friendships, source: :user

  mount_uploader :avatar, AvatarUploader


  def generate_authentication_token
     self.authentication_token = Devise.friendly_token
  end

  def admin?
    self.role == "admin"
  end

  def friend?(user)
    self.friends.include?(user) || self.inverse_friends.include?(user)
  end

  # status: false
  def request_friend?(user)
    self.request_friends.include?(user)
  end

  # status: false
  def inverse_request_friend?(user)
    self.inverse_request_friends.include?(user)
  end

  def all_friends
    friends = self.friends + self.inverse_friends
    return friends.uniq
  end

end
