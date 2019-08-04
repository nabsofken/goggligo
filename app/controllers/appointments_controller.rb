class AppointmentsController < ApplicationController
  before_action :authenticate_user!

  def new
  	@appointment = Appointment.new
  end

  def create
  	@appointment = Appointment.new(appointment_params)
  	if @appointment.save
  		redirect_to appointments_list_path
  	else
  		render :new
  	end
  end

  def list
  	@appointments = Appointment.all.order('created_at DESC')
  end

  def generate_report
  	header = '<h1>Patient Registered!</h1>'
  	body = '<table><tr><th>First Name</th><th>Last Name</th><th>Email</th><th>Mobile Number</th><th>Date Of Visit</th><th>Reason Of Visit</th></tr>'
  	next_column = '</td><td>'

  	@appointments = Appointment.all.order('created_at DESC')

  	@appointments.each do |appointment|
  		body = body + '<tr><td>' + appointment.first_name.to_s + next_column + appointment.last_name.to_s + next_column + appointment.email.to_s + next_column + appointment.mobile_number.to_s + next_column + appointment.date_of_visit.to_s + next_column + appointment.reason_of_visit.to_s + '</td></tr>'
  	end

  	footer = '</table><h1>Goggligo Tech</h1>'
	pdf = WickedPdf.new.pdf_from_string(header + body + footer)


	UserMailer.generate_report(current_user, pdf).deliver_later

	# attachments['report.pdf'] = pdf#File.read('path/to/file.pdf')
 #    mail(:to => current_user.email, :subject => "Patient Report")

  	redirect_to appointments_list_path
  end

  def appointment_params
  	params.require(:appointment).permit(:first_name, :last_name, :email, :mobile_number, :date_of_visit, :reason_of_visit)
  end
end
