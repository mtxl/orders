class OrderDrop < Liquid::Drop

  ORDER_ATTR = %w(attendees price quanitity)

  def initialize(order)
    @order = order
  end


  def before_method(meth)
    if ORDER_ATTR.include? meth 
      @order[meth]
    end
  end

  def sum 
    @order["price"]*@order["quantity"]
  end

end
