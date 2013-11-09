class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|

      t.references :user
      t.references :post
      t.references :comment
      t.timestamps
    end
  end
end
