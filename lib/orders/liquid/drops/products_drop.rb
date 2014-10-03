class ProductDrop < Liquid::Drop

  PRODUCT_ATTR = %w(title start_at end_at schedule)

  def initialize(product)
    @product = product
  end

  def before_method(meth)
    if PRODUCT_ATTR.include? meth 
      @product[meth]
    end
  end

end
