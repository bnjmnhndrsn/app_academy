class Dropcatrentalcolumn < ActiveRecord::Migration
  def change
    remove_column :cat_rental_requests, :cat_id_id
    add_column :cat_rental_requests, :cat_id, :integer, NULL: false

    add_index :cat_rental_requests, :cat_id
  end
end
