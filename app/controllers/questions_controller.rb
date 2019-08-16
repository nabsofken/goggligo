class QuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:edit, :show, :update]

  load_and_authorize_resource

  def new
  	@question = Question.new
  end

  def edit
  end

  def show    
  end

  def create_question
  	@question = Question.new(question_params)
  	if @question.save
  		redirect_to questions_path
  	else
  		render :new
  	end
  end

  def update
    if @question.update(question_params)
      redirect_to questions_path
    else
      render :edit
    end
  end

  def set_question
    @question = Question.find_by(id: params[:id])
    redirect_to questions_path if @question.blank?
  end

  def index
    @questions = current_user.questions + Question.template if current_user.doctor?
    if current_user.admin?
      @questions = Question.all.order('created_at DESC') if params[:user_id].blank?
      user = User.find_by_id(params[:user_id])
      @questions = user.questions + Question.template if user.present?
    end

    @questions = @questions.where('title LIKE ?', "%#{params[:search]}%") if params[:search].present?
  end


  def template
    @questions = Question.template.order('created_at DESC')
    @questions = @questions.where('title LIKE ?', "%#{params[:search]}%") if params[:search].present?
  end

  def question_params
  	params.require(:question).permit(:title, :placeholder, :question_type, :active, :required, :options, :user_id, :template, :pre_condition_question_id, :pre_condition_question_value)
  end
end
