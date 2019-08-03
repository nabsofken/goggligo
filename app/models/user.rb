class User < ActiveRecord::Base
devise :database_authenticatable, :registerable, :confirmable, :recoverable, stretches: 12

def full_name
	[self.first_name, self.last_name].join(' ')
end

end
