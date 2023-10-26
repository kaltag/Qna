class AddTypeAttributeToLinks < ActiveRecord::Migration[7.0]
  def change
    add_column :links, :type, :string, null: false, default: 'Link'
    add_index :links, :type
  end
end
