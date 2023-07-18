class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.integer :role, default: 0
      t.references :university, null: false, foreign_key: true
      t.boolean :paid, default: false
      t.integer :listmonk_id

      t.timestamps
    end
  end
end
