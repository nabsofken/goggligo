require 'csv'

class Appointment < ActiveRecord::Base
	belongs_to :user
	serialize :answer_values
	#after_create :send_report
  	attr_accessor :current_user

    scope :between, -> (start_date, end_date) { where('created_at BETWEEN ? AND ?', start_date.to_datetime.beginning_of_day, end_date.to_datetime.end_of_day) }

	validates_format_of :mobile_number, with: /\(?[0-9]{3}\)? ?[0-9]{3}-[0-9]{4}/, message: "- Phone numbers must be in xxx-xxx-xxxx format."

	def self.to_csv(appointments)
	    attributes = %w{first_name last_name email mobile_number date_of_visit reason_of_visit}

	    CSV.generate(headers: true) do |csv|
	      csv << attributes

	      appointments.each do |appointment|
	        csv << attributes.map{ |attr| appointment.send(attr) }
	      end
	    end
	end

	def send_report
		appointment = self
		header = '<h1 style="text-align: center; color: #4285F4">Visitor Report!</h1>'
	  	body = '<h3><strong>First Name: </strong></h3>' + appointment.first_name.to_s +
	  	       '<h3><strong>Last Name: </strong></h3>' + appointment.last_name.to_s +
	  	       '<h3><strong>Email: </strong></h3>' + appointment.email.to_s +
	  	       '<h3><strong>Mobile Number: </strong></h3>' + appointment.mobile_number.to_s +
	  	       '<h3><strong>Date Of Visit: </strong></h3>' + appointment.date_of_visit.to_s +
	  	       '<h3><strong>Reason Of Visit: </strong></h3>' + appointment.reason_of_visit.to_s +
	  	       '<h3><strong>Questions: </strong></h3><ul>'

        appointment.answer_values.keys.each do |key|
            body = body + '<li>' + Question.find_by_id(key.to_s).try(:title) + ': <strong>' + appointment.answer_values[key].to_s + '</strong></li>'
        end

  		body + '</ul>'
  	
	  	footer = '<h1 style="text-align: center; color: #2DAD68">Gliggo</h1>'
		pdf = WickedPdf.new.pdf_from_string(header + body + footer)
		UserMailer.generate_patient_report(self, pdf, self.current_user).deliver_later
	end

end
