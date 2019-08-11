class Question < ActiveRecord::Base
  belongs_to :user

  enum question_type: { Text: 0, Number: 1, MCQs: 2, Date: 3 }
  scope :template, -> { where(template: true) }
  scope :not_template, -> { where(template: false) }


end
