class Api::V1::QuestionsController < ApiController
  include Concerns::UserAuthentication


  def index
    questions = Question.all
    success(data: ActiveModelSerializers::SerializableResource.new(questions, each_serializer: QuestionSerializer, scope: {current_user: @current_user}))
  end
end
