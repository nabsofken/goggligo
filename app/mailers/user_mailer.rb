class UserMailer < ApplicationMailer
  default from: 'reports@goggligo.herokuapp.com'
   layout "mailer"

  def generate_report(user, pdf)
    @user = user

	attachments['report.pdf'] = pdf#File.read('path/to/file.pdf')

    mail(to: @user.email,
         subject: 'Goggligo Patients Report')
  end
end