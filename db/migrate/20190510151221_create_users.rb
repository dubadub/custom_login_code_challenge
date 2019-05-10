class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :handle
      t.string :encrypted_password
      t.string :salt
      t.integer :failed_logins_count, default: 0, null: false

      t.timestamps
    end
    add_index :users, :handle, unique: true
  end
end
