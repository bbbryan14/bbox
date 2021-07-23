class AddLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :likes, id: false do |t|
      t.belongs_to :users
      t.belongs_to :dogs
      t.timestamp :disliked_on, null: true
      t.timestamps
    end
  end
end
