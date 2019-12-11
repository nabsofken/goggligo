class Question < ActiveRecord::Base
  belongs_to :user

  enum question_type: { Text: 0, Number: 1, MCQs: 2, Date: 3, Gender: 4, InsuranceNumber: 5, MobileNumber: 6, Email: 7 }
  scope :template, -> { where(template: true) }
  scope :not_template, -> { where(template: false) }

  validates :title, presence: true
  validates :pre_condition_question_value, presence: true, if: "pre_condition_question_id.present?"

  def self.preview(questions)
    body = ''
    questions = questions.sort_by{|e| [e.template? ? 0 : 1, e.id] }

    body = '<body style="font-size: 16px;line-height: 1.4;width:100%;height:500px;"><div style="width: 20%;margin: auto;margin-top: 1%;font-size: 16px;color: #2DAD68"><strong>Gliggo Visitor - Report</strong></div><section style="border: 1px solid black;margin: 20px;width: 90%;margin-left: 5%;margin-right: 5%;padding: 0.5rem;"><header style="border-bottom: 10px solid black;padding: 0 0 0.25rem 0;margin: 0 0 0.5rem 0;"><h1 style="font-weight: bold;font-size: 2rem;margin: 0 0 0.25rem 0;color: #2DAD68">Client Detail</h1></header>'

    questions.each do |question|
      if question.question_type != 'MCQs'
        body = body + '<div style="font-size: 16px;padding-top: 0.5rem;padding-bottom: 1rem;">' + question.title + '</div><strong>' + ' ' + '</strong><div style="border-bottom: 1px solid black;margin-bottom: 0.5rem;"></div>'
      else
        body = body + '<table style="border-collapse: collapse;margin: 0 0 0.5rem 0;"><tbody>'
        body = body + '<tr><th colspan="2">' + question.title + '</th>'
        body = body + '<td colspan="6">Yes<input type="checkbox"></td>'
        body = body + '<td colspan="6">No<input type="checkbox"></td>'
        body = body + '</tr>'
        body = body + '</tbody></table>'
      end
    end

    body = body + '<p style="padding-bottom: 5rem;">Recommandations:</p>'
    body = body + '<p style="font-size: 0.7rem; text-align: center;">'
    body = body + 'Gliggo Visitor Report</p></section></body>'

    pdf = WickedPdf.new.pdf_from_string(body, dpi: 75, lowquality: true, zoom: 1)
    pdf
  end
end
