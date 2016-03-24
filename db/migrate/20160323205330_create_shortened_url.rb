class CreateShortenedUrl < ActiveRecord::Migration
  def change
    create_table :shortened_urls do |t|
      t.string :short_url, null: false
      t.string :long_url, null: false
      t.integer :submitter_id, null: false
    end
    add_foreign_key :shortened_urls, :users, name: :submitter_id
  end
end
