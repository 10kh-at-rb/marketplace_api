class CreatesOrder
  def initialize(user)
    @user  = user
    @order = Order.create(user: user)
  end

  def from_list(a_list)
    a_list.each do |product_id, quantity|
      add_product_entry(product_id, quantity)
    end
    @order
  rescue
    nil
  end

  def add_product_entry(product_id, quantity)
    ProductEntry.create(
      product_id: product_id, quantity: quantity.to_i, order_id: @order.id
    )
    Product.find(product_id).decrement!(:quantity, quantity.to_i)
  end
end
