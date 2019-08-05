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
  	@appointments = current_user.appointments.order('created_at DESC')
  end

  def generate_csv
  	respond_to do |format|
      format.html
      format.csv { send_data Appointment.to_csv(current_user), filename: "Patients-#{Date.today}.csv" }
    end
  end

  def generate_report
  	header = '<h1 style="text-align: center; color: #4285F4">Patients Report!</h1>'
  	body = '<table><tr><th>Full Name</th><th>Email</th><th>Mobile</th><th>Date</th><th>Reason</th><th>Questions</th></tr>'
  	next_column = '</td><td>'

  	@appointments = current_user.appointments.order('created_at DESC')

  	@appointments.each do |appointment|
  		body = body + '<tr><td>' + appointment.first_name.to_s + ' ' + appointment.last_name.to_s + next_column + appointment.email.to_s + next_column + appointment.mobile_number.to_s + next_column + appointment.date_of_visit.to_s + next_column + appointment.reason_of_visit.to_s

		body = body + '</td><td><ul>'
        appointment.answer_values.keys.each do |key|
            body = body + '<li>' + Question.find_by_id(key.to_s).try(:title) + ': <strong>' + appointment.answer_values[key].to_s + '</strong></li>'
        end

  		body + '</ul></td></tr>'
  	end

  	footer = '</table><h1 style="text-align: center; color: #2DAD68">Goggligo Tech</h1>'
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
