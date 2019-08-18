class Question < ActiveRecord::Base
  belongs_to :user

  enum question_type: { Text: 0, Number: 1, MCQs: 2, Date: 3, Gender: 4, InsuranceNumber: 5, MobileNumber: 6 }
  scope :template, -> { where(template: true) }
  scope :not_template, -> { where(template: false) }

  validates :title, :placeholder, presence: true
  validates :pre_condition_question_value, presence: true, if: "pre_condition_question_id.present?"

end
