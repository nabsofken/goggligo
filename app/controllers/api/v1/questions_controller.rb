class Api::V1::QuestionsController < ApiController
  include Concerns::UserAuthentication


  def index
    questions = current_user.questions + Question.template
    questions = questions.sort_by{|e| e[:id]}
    success(data: ActiveModelSerializers::SerializableResource.new(questions, each_serializer: QuestionSerializer, scope: {current_user: @current_user}))
  end
end
