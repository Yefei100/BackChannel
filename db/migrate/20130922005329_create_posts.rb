class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.float :post_vote_count
      t.float :total_vote_count
      t.datetime :last_update_time

      t.references :user
      t.references :category
      t.timestamps
    end
  end
end
