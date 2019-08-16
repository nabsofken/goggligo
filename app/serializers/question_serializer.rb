class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :type, :placeholder, :options, :dateformat, :health_card_format, :phone_number_format, :required, :conditions, :template, :question_key, :pre_condition_question_id, :pre_condition_question_value

  def type
  	self.object.question_type
  end

  def dateformat
	'xx-xx-xxxx'
  end

  def health_card_format
     'xxxx-xxx-xxx'
  end


  def phone_number_format
    'xxxx-xxxxxx'
  end

  def conditions
  	[]
  end

  def options
  	result = []
  	self.object.options.each do |option|
  		result << { text: option, value: option }
  	end
  	result
  end

end
