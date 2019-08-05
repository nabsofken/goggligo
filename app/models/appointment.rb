class Appointment < ActiveRecord::Base
	belongs_to :user
	serialize :answer_values
	after_create :send_report
  	attr_accessor :current_user


	def send_report
		header = '<h1>Patient Registered!</h1>'
	  	body = '<table><tr><th>First Name</th><th>Last Name</th><th>Email</th><th>Mobile Number</th><th>Date Of Visit</th><th>Reason Of Visit</th><th>Questions</th></tr>'
	  	next_column = '</td><td>'

	  	appointment = self
  		body = body + '<tr><td>' + appointment.first_name.to_s + next_column + appointment.last_name.to_s + next_column + appointment.email.to_s + next_column + appointment.mobile_number.to_s + next_column + appointment.date_of_visit.to_s + next_column + appointment.reason_of_visit.to_s

		body = body + '</td><td><ul>'
        appointment.answer_values.keys.each do |key|
            body = body + '<li>' + Question.find_by_id(key.to_s).try(:title) + ': <strong>' + appointment.answer_values[key].to_s + '</strong></li>'
        end

  		body + '</ul></td></tr>'
  	
	  	footer = '</table><h1>Goggligo Tech</h1>'
		pdf = WickedPdf.new.pdf_from_string(header + body + footer)
		UserMailer.generate_report(self.current_user, pdf, self.email).deliver_later
	end

end
