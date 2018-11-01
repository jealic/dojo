class Reply < ApplicationRecord
  belongs_to :user, counter_cache: true
  belongs_to :post, counter_cache: true

  after_save :match_post_last_replied_at

  def match_post_last_replied_at
    self.post.update(last_replied_at: self.updated_at)
  end
end
