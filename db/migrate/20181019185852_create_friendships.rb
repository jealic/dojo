class CreateFriendships < ActiveRecord::Migration[5.1]
  def change
    create_table :friendships do |t|
      t.integer :user_id
      t.integer :friend_id
      t.string :invite, default: "pending"
      t.timestamps
    end
    add_index :friendships, [:user_id, :friend_id]
  end
end
