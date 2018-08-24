class ClientSerializer < ActiveModel::Serializer
  attributes :id,
    :identicon,
    :rfc,
    :social_name,
    :legal_representative,
    :comercial_name,
    :responsible,
    :phone,
    :location,
    :contract,
    :total_oil_sum,
    :invoices_count

  has_many :emails

  def location
    object.location
  end

  def contract
    object.contract
  end

  def identicon
    Digest::SHA1.hexdigest(object.social_name) 
  end
end
