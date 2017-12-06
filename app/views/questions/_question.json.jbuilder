json.id question.id
json.published question.published
json.answers_count question.answers_count
json.body question.body
json.shopify_product_id question.product.shopify_id
json.created_at question.created_at.strftime("%d %B, %Y")

json.answers do
  json.array! question.answers, partial: 'answers/answer', as: :answer
end
