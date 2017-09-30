json.questions do
  json.array! @questions do |question|
    json.id question.id
    json.body question.body
    json.shopify_product_id question.product.shopify_id
    json.created_at question.created_at.strftime("%d %b, %Y")
  end
end
