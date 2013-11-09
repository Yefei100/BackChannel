class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :hashed_password
      t.string :salt
      t.string :email_address
      t.boolean :isadmin
      t.boolean :issuperadmin

      t.timestamps
    end
  end
end
