class User < ActiveRecord::Base
devise :database_authenticatable, :registerable, :confirmable, :recoverable, stretches: 12

has_many :user_identities

def full_name
	[self.first_name, self.last_name].join(' ')
end

def generate_access_token(device_id)
	user_identity = user_identities.find_or_create_by(device_id: device_id)
	user_identity.access_token
end

end
