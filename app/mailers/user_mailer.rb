class UserMailer < ApplicationMailer
  default from: 'reports@goggligo.herokuapp.com'
   layout "mailer"

  def generate_report(user, pdf, bcc=nil)
    @user = user

	attachments['report.pdf'] = pdf#File.read('path/to/file.pdf')

    mail(to: @user.email,
    	bcc: bcc,
         subject: 'Goggligo Patients Report')
  end
end