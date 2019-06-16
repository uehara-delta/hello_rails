class AddColumnToEntry < ActiveRecord::Migration[5.2]
  def change
    add_column :entries, :blog_id, :integer
  end
end
