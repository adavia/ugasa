class Location < ApplicationRecord
	validates_presence_of :zone

	self.per_page = 15

	scope :search, -> (query) do 
    where(["zone LIKE ?", "%#{query}%"]) 
  end
end
