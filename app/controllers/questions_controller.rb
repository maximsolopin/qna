class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :check_author, only: [:destroy, :update]

  def index
    @questions = Question.all
  end

  def show
    @answers = @question.answers.all
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.new(question_params)
    @question.user = current_user

    if @question.save
      flash[:notice] = 'Your question successfully created'
      redirect_to @question
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    flash[:notice] = 'Question deleted'
    redirect_to questions_path
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def check_author
    if @question.user.id != current_user.id
      flash[:alert] = 'Permision denied'
      redirect_to @question
    end
  end
end
