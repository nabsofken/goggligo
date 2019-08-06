class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :created_at, :last_sign_in_at, :active, :business_name, :address, :phone, :fax, :website, :email, :contact_person_email, :contact_person_number
end
