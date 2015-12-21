class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :value
      t.references :votable, polymorphic: true, index: true
      t.timestamps null: false
    end

    add_index :votes, [:votable_id, :votable_type]
  end
end
