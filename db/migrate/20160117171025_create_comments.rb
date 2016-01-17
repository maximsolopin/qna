class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, index: true, foreign_key: true
      t.text :body
      t.references :commentable, polymorphic: true, index: true

      t.timestamps null: false
    end

    add_index :comments, [:commentable_id, :commentable_type]
  end
end
