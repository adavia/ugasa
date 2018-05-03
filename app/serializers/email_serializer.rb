class EmailSerializer < ActiveModel::Serializer
  attributes :id, :address, :_destroy
end
