class QuestionsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def new
  	@question = Question.new
  end

  def create
  	@question = Question.new(question_params)
  	if @question.save
  		redirect_to questions_list_path
  	else
  		render :new
  	end
  end

  def list
  	@questions = current_user.questions.order('created_at DESC') if current_user.doctor?
    @questions = Question.all.order('created_at DESC') if current_user.admin?
  end

  def question_params
  	params.require(:question).permit(:title, :placeholder, :question_type, :active, :required, :options, :user_id)
  end
end
