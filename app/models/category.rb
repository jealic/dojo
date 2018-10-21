class Category < ApplicationRecord
  validates_uniqueness_of :name, case_sensitive: false #不分大小寫
  validates_presence_of :name #一定要有值
  
  has_many :post_categoryships
  has_many :posts, through: :post_categoryships, dependent: :restrict_with_error
end
