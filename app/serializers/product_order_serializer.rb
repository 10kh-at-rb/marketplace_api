class ProductOrderSerializer < ProductSerializer
  def include_user?; false; end
end
