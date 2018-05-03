class InvoiceSerializer < ActiveModel::Serializer
  attributes :id,
    :code,
    :receiver,
    :invoice_date,
    :total,
    :notes,
    :client

  has_one :client
end
