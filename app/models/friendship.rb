class Friendship < ApplicationRecord
  validate_uniqueness_of :user_id, :scope => :friend_id

  belongs_to :user_id
  belongs_to :friend, class_name: 'User'
end
