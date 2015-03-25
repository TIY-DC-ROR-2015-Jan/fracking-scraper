class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.belongs_to :user, index: true
      t.string :key, null: false
      t.datetime :expires_at
      t.boolean :active, null: false, default: true

      t.timestamps null: false
    end
    add_foreign_key :tokens, :users
  end
end
