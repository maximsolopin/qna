class RemoveDisplayNameFromUsers < ActiveRecord::Migration
  def change
    remove_index  :users, :display_name
    remove_column :users, :display_name
  end
end
