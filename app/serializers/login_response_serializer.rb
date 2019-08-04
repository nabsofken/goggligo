class LoginResponseSerializer < ActiveModel::Serializer
  attributes :user, :access_token

  def access_token
    scope[:access_token]
  end

  def user
    UserSerializer.new(object , {root: false})
  end
end
