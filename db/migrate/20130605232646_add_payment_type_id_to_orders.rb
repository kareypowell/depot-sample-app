class AddPaymentTypeIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :payment_type_id, :integer

    Order.reset_column_information
    Order.all.each do |order|
      order.payment_type_id = case order.pay_type
                              when 'Check'
                                1
                              when 'Credit Card'
                                2
                              when 'Purchase Order'
                                3
                              end
      order.save validate: false
    end
    Order.reset_column_information
    remove_column :orders, :pay_type
  end
end
