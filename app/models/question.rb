class Question < ActiveRecord::Base
  enum question_type: { Text: 0, Number: 1, MCQs: 2, Date: 3 }

end
