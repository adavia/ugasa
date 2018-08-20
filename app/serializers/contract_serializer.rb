class ContractSerializer < ActiveModel::Serializer
  attributes :id,
    :oil_payment,
    :contract_date,
    :contract_end,
    :contact,
    :address,
    :bank_name,
    :bank_account,
    :_destroy
end
