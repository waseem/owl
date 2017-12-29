class Question < ApplicationRecord
  belongs_to :product
  belongs_to :shop
  belongs_to :asker, class_name: "Customer"

  has_many :answers

  scope :new_first,   -> { order("id DESC") }
  scope :published,   -> { where(published: true) }

  validates :body, presence: true, length: { in: 16..256 }
end
