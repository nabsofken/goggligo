class UserMailer < ApplicationMailer
  default from: 'reports@goggligo.herokuapp.com'
   layout "mailer"

  def generate_report(user, pdf)
    @user = user

	attachments['report_' + Date.today.to_s + '.pdf'] = pdf

    mail(to: @user.email, subject: 'Goggligo Visitors Report')
  end

  def generate_patient_report(appointment, pdf, user)
  	@appointment = appointment
    @user = user
    bcc = appointment.email

	attachments['report_' + appointment.first_name.to_s + "_" + appointment.last_name.to_s + '.pdf'] = pdf

    mail(to: @user.email,
    	bcc: bcc,
        subject: 'Goggligo Visitor Report')
  end
end