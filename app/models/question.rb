class Question < ApplicationRecord
  belongs_to :product
  belongs_to :shop

  validates :body, presence: true, length: { in: 16..250 }
end
