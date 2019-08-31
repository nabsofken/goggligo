class AppointmentSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :mobile_number, :date_of_visit, :reason_of_visit, :answer_values

  def answer_values
    result = []
    if self.object.answer_values.present?
      self.object.answer_values.keys.each do |key|
        question = Question.find_by_id(key.to_s)
        next unless question.present?
        result << { id: question.id , title: question.title, value: self.object.answer_values[key] }
      end
    end
    result
  end

end
