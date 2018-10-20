class ChangeColumnsNames < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :description, :intro
    rename_column :posts, :description, :content
  end
end
