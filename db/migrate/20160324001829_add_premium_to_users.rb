class AddPremiumToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.boolean :premium, default: false, null: false
    end
  end
end
