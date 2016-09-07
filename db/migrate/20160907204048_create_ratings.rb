class CreateRatings < ActiveRecord::Migration[5.0]
  def change
    create_table :ratings do |t|
      t.string :tag, index: true
      t.integer :value
      t.string :request_ip, index: true

      t.timestamps
    end
  end
end
