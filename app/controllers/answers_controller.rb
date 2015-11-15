class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_user, except: [:index]
  before_action :set_question, only: [:new, :create]
  before_action :set_answer, only: [:show, :edit, :destroy, :update]



  def index
    @answers = Answer.all
  end

  def show

  end

  def new
    @answer = Answer.new
  end

  def edit
  end

  def create
    @answer = @question.answers.new(answer_params.merge({ user: @user }))

    if @answer.save
      redirect_to @question
    else
      render :new
    end
  end

  def update
    if @answer.user == @user
      if @answer.update(answer_params)
        flash[:notice] = 'Answer updated'
        redirect_to @answer.question
      else
        render :edit
      end
    else
      flash[:alert] = 'Permision denied'
      redirect_to question_answers_path(question)
    end
  end

  def destroy
    if @answer.user == @user
      @answer.destroy
      flash[:notice] = 'Answer deleted'
    else
      flash[:alert] = 'Permision denied'
    end
    redirect_to @answer.question
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_user
    @user = current_user
  end
end
