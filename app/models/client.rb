class Client < ApplicationRecord
  has_one :contract, dependent: :destroy
  has_many :emails, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :attachments, as: :attacheable, dependent: :destroy

  # Pagination
  self.per_page = 16

  # Nested attributes
  accepts_nested_attributes_for :contract, allow_destroy: true
  accepts_nested_attributes_for :emails, allow_destroy: true

  # Validations
  validates_presence_of :social_name, :comercial_name, :zone

  scope :search, -> (query) do 
    where(["social_name LIKE ? OR comercial_name LIKE ?", "%#{query}%", "%#{query}%"]) 
  end
end
