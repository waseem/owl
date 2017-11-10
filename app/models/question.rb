class Question < ApplicationRecord
  belongs_to :product
  belongs_to :shop
  belongs_to :asker, class_name: "Customer"

  scope :new_first, -> { order("id DESC") }

  validates :body, presence: true, length: { in: 16..256 }
end
