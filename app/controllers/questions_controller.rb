class QuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:edit, :show, :update, :destroy]

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
      session[:notice] = 'Successfully created new question'
      return redirect_to questions_template_path if @question.template
  		redirect_to questions_path
  	else
      @error = @question.errors.full_messages.to_sentence
  		render :new
  	end
  end

  def update
    if @question.update(question_params)
      session[:notice] = 'Successfully updated question'
      redirect_to questions_path
    else
      @error = @question.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    if @question.destroy
      session[:notice] = 'Successfully deleted question'
    else
      session[:error] = 'Failed to deleted question'
    end
    redirect_to questions_path
  end

  def set_question
    @question = Question.find_by(id: params[:id])
    if @question.blank?
      session[:error] = 'No question found'
      redirect_to questions_path
    end
  end

  def index
    @notice = session[:notice]
    session[:notice] = nil
    @error = session[:error]
    session[:error] = nil
    @questions = Question.where("user_id = ? OR template = ?", current_user.id, true) if current_user.doctor?

    if current_user.admin?
      @questions = Question.all.order('created_at DESC') if params[:user_id].blank?
      user = User.find_by_id(params[:user_id])
      @questions = user.questions + Question.template if user.present?
    end

    @questions = @questions.where('lower(title) LIKE ?', "%#{params[:search].downcase}%") if params[:search].present?
    @questions = @questions.sort_by{|e| e[:id]}
  end


  def template
    @notice = session[:notice]
    session[:notice] = nil
    @error = session[:error]
    session[:error] = nil
    @questions = Question.template.order('created_at DESC')
    @questions = @questions.where('lower(title) LIKE ?', "%#{params[:search].downcase}%") if params[:search].present?
    @questions = @questions.sort_by{|e| e[:id]}
  end

  def question_params
  	params.require(:question).permit(:title, :placeholder, :question_type, :active, :required, :options, :user_id, :template, :pre_condition_question_id, :pre_condition_question_value)
  end
end
