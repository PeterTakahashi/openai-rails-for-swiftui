class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :apple_user_id
      t.string :email
      t.string :fullname
      t.integer :token

      t.timestamps
    end
  end
end
