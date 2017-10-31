class Question < ApplicationRecord
  belongs_to :product
  belongs_to :shop
  belongs_to :asker, class_name: "Customer"

  validates :body, presence: true, length: { in: 16..250 }
end
