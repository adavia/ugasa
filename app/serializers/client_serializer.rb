class ClientSerializer < ActiveModel::Serializer
  attributes :id,
    :identicon,
    :rfc,
    :social_name,
    :legal_representative,
    :comercial_name,
    :responsible,
    :phone,
    :zone,
    :total_oil_sum,
    :invoices_count

  has_one :contract
  has_many :emails

  def identicon
    Digest::SHA1.hexdigest(object.social_name) 
  end
end
