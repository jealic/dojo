class PostCategoryship < ApplicationRecord
  validates :post_id, uniqueness: { scope: :category_id }

  belongs_to :post
  belongs_to :category
end
