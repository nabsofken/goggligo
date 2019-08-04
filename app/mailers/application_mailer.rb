class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@goggligo.herokuapp.com'
  layout 'mailer'
end