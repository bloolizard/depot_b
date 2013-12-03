class AddQuanityToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :quanity, :integer, default: 1
  end
end
