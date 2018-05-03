class Contract < ApplicationRecord
  belongs_to :client

  validates_presence_of :contract_date, :contract_end, :oil_payment
  validates :oil_payment, numericality: true
end
