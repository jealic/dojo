class Category < ApplicationRecord
  validates_uniqueness_of :name
  has_many :post_categoryships
  has_many :posts, through: :post_categoryships, dependent: :restrict_with_error
end
