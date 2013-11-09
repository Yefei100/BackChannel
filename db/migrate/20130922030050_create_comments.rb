class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :title
      t.text :content
      t.float :vote_number

      t.references :user
      t.references :post
      t.timestamps
    end
  end
end
