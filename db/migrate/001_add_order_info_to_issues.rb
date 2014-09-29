class AddOrderInfoToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :order_info, :text
  end
end
