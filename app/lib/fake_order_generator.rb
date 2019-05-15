require_relative './affiliate.rb'
require_relative './reseller.rb'

class FakeOrderGenerator
  def initialize(order_count = 100)
    @order_count = order_count
    @direct_sales_count = 0
    @generated_orders = generate_orders
    assign_generated_orders
  end

  def affiliates
    @affiliates ||= [
      Affiliate.new("ACompany", 75.0),
      Affiliate.new("AnotherCompany", 65.0),
      Affiliate.new("EvenMoreCompany", 80.0)
    ]
  end

  def resellers
    @resellers ||= [
      Reseller.new("ResellThis", 75.0),
      Reseller.new("SellMoreThings", 85.0)
    ]
  end

  def sellers
    affiliates + resellers
  end

  attr_reader :order_count, :direct_sales_count, :generated_orders

  private

  def assign_generated_orders
    generated_orders.each do |order|
      if order[:sale_method] == "direct"
        @direct_sales_count += order[:quantity_of_widgets]
      else
        assign_order_to_seller(order)
      end
    end
  end

  def generate_orders
    @generated_orders ||= (
      order_list = []
      order_count.times do
        order_list << generate_order
      end
      order_list
    )
  end

  def generate_order
    sale_type_seed = rand(0..5)
    {
      quantity_of_widgets: rand(1..100),
      sale_method: sale_types[sale_type_seed][:type],
      amount_paid: sale_types[sale_type_seed][:price]
    }
  end

  def sale_types
    @sale_types ||= [
      {type: "direct", price: 100.0},
      {type: "ACompany", price: 75.0},
      {type: "AnotherCompany", price: 65.0},
      {type: "EvenMoreCompany", price: 80.0},
      {type: "ResellThis", price: 75.0},
      {type: "SellMoreThings", price: 85.0}
    ]
  end

  def assign_order_to_seller(order)
    sellers = affiliates + resellers
    sellers.detect do |seller|
      seller.name == order[:sale_method]
    end.order_widgets(order[:quantity_of_widgets])
  end
end
