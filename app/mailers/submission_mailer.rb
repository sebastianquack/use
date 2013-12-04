class SubmissionMailer < ActionMailer::Base
  default from: "info@utopiastockexchange.de"

  def confirmation(utopia)
  	@utopia = utopia
    mail(to: @utopia.email, subject: 'Vielen Dank')
  end


end
