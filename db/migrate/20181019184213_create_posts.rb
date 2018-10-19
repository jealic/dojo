class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :image
      t.boolean :draft, null: false, default: true
      t.integer :privacy, default: 1
      t.integer :replies_count, default: 0
      t.integer :viewed_count, default: 0
      
      t.reference :user, foreign_key: true

      t.timestamps
    end
  end
end
