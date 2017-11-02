class Customer < ApplicationRecord
  has_many :questions
  belongs_to :shop

  validate :atleast_one_identifier_present

  private

  def atleast_one_identifier_present
    if self.shopify_id.blank?
      errors.add(:email, "can not be blank") if self.email.blank?
      errors.add(:name,  "can not be blank") if self.name.blank?
    end
  end
end
