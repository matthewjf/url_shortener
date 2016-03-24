class Visit < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.integer :user_id, null: false, index: true
      t.integer :shortened_url_id, null: false, index: true
      t.timestamps
    end
    add_foreign_key :visits, :users
    add_foreign_key :visits, :shortened_urls
  end
end
