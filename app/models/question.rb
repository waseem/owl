class Question < ApplicationRecord
  belongs_to :product

  validates :body, presence: true, length: { in: 16..250 }
end
