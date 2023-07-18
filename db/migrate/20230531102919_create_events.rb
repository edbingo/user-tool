class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :date
      t.string :location
      t.boolean :current
      t.string :filename
      t.string :article
      t.string :map
      t.string :pictures
      t.string :signup_link
      t.string :signup_text
      t.string :participants

      t.timestamps
    end
  end
end
