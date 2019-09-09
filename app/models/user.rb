class User < ActiveRecord::Base
devise :database_authenticatable, :registerable, :recoverable, :timeoutable, stretches: 12

has_many :user_identities, dependent: :destroy
has_many :appointments, dependent: :destroy
has_many :questions, dependent: :destroy
scope :doctors, -> { where(role: 'doctor') }
before_create :set_default_password

validates_format_of :contact_person_number, :phone, :fax, with: /\(?[0-9]{3}\)? ?[0-9]{3}-[0-9]{4}/, message: "- must be in xxx-xxx-xxxx format."

def full_name
	[self.first_name, self.last_name].join(' ')
end

def generate_access_token(device_id)
	user_identity = user_identities.find_or_create_by(device_id: device_id)
	user_identity.access_token
end

def admin?
	self.role == 'admin'
end

def doctor?
	self.role == 'doctor'
end


  def set_default_password
    self.password = self.phone.tr('^0-9', '') if self.phone.present?
    self.password_visible = self.password
  end
end
