class Email < ApplicationRecord
  belongs_to :client
  validates_presence_of :address
end
