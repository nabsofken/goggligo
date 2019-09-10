require 'csv'

class Appointment < ActiveRecord::Base
	belongs_to :user
	serialize :answer_values
	after_create :send_report
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

    body = '<body style="font-size: 16px;line-height: 1.4;width:100%;height:500px;"><div style="width: 20%;margin: auto;margin-top: 1%;font-size: 16px;color: #2DAD68"><strong>Gliggo Visitor - Report</strong></div><section style="border: 1px solid black;margin: 20px;width: 90%;margin-left: 5%;margin-right: 5%;padding: 0.5rem;"><header style="border-bottom: 10px solid black;padding: 0 0 0.25rem 0;margin: 0 0 0.5rem 0;"><h1 style="font-weight: bold;font-size: 2rem;margin: 0 0 0.25rem 0;color: #2DAD68">Client Detail</h1></header>'

    appointment.answer_values && Question.where(id: appointment.answer_values.keys).where.not(question_type: 2).each do |question|
      body = body + '<div style="font-size: 16px;padding-top: 0.5rem;padding-bottom: 0.5rem;">' + question.title + '</div><strong>' + appointment.answer_values[question.id.to_s].to_s + '</strong><div style="border-bottom: 1px solid black;margin-bottom: 0.5rem;"></div>'
    end

    body = body + '<table style="border-collapse: collapse;margin: 0 0 0.5rem 0;"><tbody>'

    appointment.answer_values && Question.where(id: appointment.answer_values.keys).where(question_type: 2).each do |question|

      body = body + '<tr><th colspan="2">' + question.title + '</th>'
      if appointment.answer_values[question.id.to_s].to_s.downcase == 'yes'
        body = body + '<td colspan="6">Yes<input type="checkbox" checked="checked"></td>'
        body = body + '<td colspan="6">No<input type="checkbox"></td>'
      elsif appointment.answer_values[question.id.to_s].to_s.downcase == 'no'
        body = body + '<td colspan="6">Yes<input type="checkbox"></td>'
        body = body + '<td colspan="6">No<input type="checkbox" checked="checked"></td>'
       else
         body = body + '<td colspan="6">appointment.answer_values[question.id.to_s].to_s.downcase<input type="checkbox checked="checked""></td>'
        body = body + '<td colspan="6">Other<input type="checkbox"></td>'
      end

      body = body + '</tr>'

    end

    body = body + '</tbody></table><div style="border-bottom: 1px solid black;margin-bottom: 0.5rem;"></div><p style="padding-bottom: 5rem;">Recommandations:</p><p><strong>Disclaimer:'
    body = body + '</strong> The information provided on Gliggo Visitor Report is intended for your general knowledge only and is not a substitute for professional medical or psychological advice or treatment for specific medical or psychological conditions. Always seek the advice of your physician or other qualified health care provider with any questions you may have regarding a medical condition. Always seek the advice of your physician or psychologist or other qualified healthcare provider with any questions you may have regarding a psychological condition. The information on this website is not intended to diagnose, treat, cure or prevent any disease.</p>'
    body = body + '<p style="font-size: 0.7rem; text-align: center;">'
    body = body + 'Gliggo Visitor Report</p></section></body>'

    pdf = WickedPdf.new.pdf_from_string(body, dpi: 75, lowquality: true, zoom: 1)
    UserMailer.generate_patient_report(self, pdf, self.current_user).deliver_later
  end

end
