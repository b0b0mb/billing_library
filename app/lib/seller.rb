class Seller
  class MethodNotImplemented < StandardError; end

  def initialize(name, widget_price)
    @name = name
    @widget_price = widget_price
    @widgets_sold = 0
  end

  attr_reader :name, :widget_price
  attr_reader :widgets_sold

  def order_widgets(quantity)
    @widgets_sold += quantity
  end

  def profit
    revenue - amount_owed_to_manufacturer
  end

  def amount_owed_to_manufacturer
    raise MethodNotImplemented, "Must implement in subclass"
  end

  private

  def revenue
    widgets_sold * widget_price
  end

end
