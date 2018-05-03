class ContractSerializer < ActiveModel::Serializer
  attributes :id,
    :oil_payment,
    :contract_date,
    :contract_end,
    :contact,
    :address,
    :_destroy
end
