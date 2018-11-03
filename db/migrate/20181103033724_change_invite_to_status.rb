class ChangeInviteToStatus < ActiveRecord::Migration[5.1]
  def change
    remove_column :friendships, :invite
    add_column :friendships, :status, :boolean, default: false
  end
end
