class AddTitleToDiscounts < ActiveRecord::Migration[5.2]
  def change
    add_column :discounts, :title, :string
  end
end
