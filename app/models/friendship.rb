class Friendship < ApplicationRecord
  validates_uniqueness_of :user_id, :scope => :friend_id 
  # table 上，只能有一筆 同樣的 friend_id - user_id 的組合，不可以重複建製多筆同樣的資料

  belongs_to :user
  belongs_to :friend, class_name: 'User'
end
