class Answer < ApplicationRecord
  belongs_to :question, counter_cache: true
  belongs_to :shop

  validates :body, presence: true, length: { minimum: 16 }
end
