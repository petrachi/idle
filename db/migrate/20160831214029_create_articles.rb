class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      
      t.string :title
      t.string :tag, index: true
      t.boolean :published, :default => false
      t.datetime :published_at

      t.timestamps
    end
  end
end
