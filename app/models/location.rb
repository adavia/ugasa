class Location < ApplicationRecord
	validates_presence_of :zone

	scope :search, -> (query) do 
    where(["zone LIKE ?", "%#{query}%"]) 
  end
end
