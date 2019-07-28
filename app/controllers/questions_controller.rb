class QuestionsController < ApplicationController
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
  	@questions = Question.all.order('created_at DESC')
  end

  def question_params
  	params.require(:question).permit(:title, :placeholder, :question_type, :active, :required, :options)
  end
end
