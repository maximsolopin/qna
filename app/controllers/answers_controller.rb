class AnswersController < ApplicationController
  before_action :set_user, except: [:index]
  before_action :set_question, only: [:new, :create, :update, :destroy]
  before_action :set_answer, only: [:show, :edit, :destroy, :update]



  def index
    @answers = Answer.all
  end

  def show

  end

  def new
    @answer = @user.answers.new
  end

  def edit
  end

  def create
    @answer = @question.answers.new(answer_params.merge({ user: @user }))

    if @answer.save
      redirect_to question_path(@question)
    else
      render :new
    end
  end

  def update
    if @question.user == @user
      if @answer.update(answer_params)
        flash[:notice] = 'Answer updated'
      else
        render :edit
      end
    else
      flash[:alert] = 'Permision denied'
    end

    redirect_to question_path(@question)
  end

  def destroy
    if @question.user == @user
      @answer.destroy
      flash[:notice] = 'Answer deleted'
    else
      flash[:alert] = 'Permision denied'
    end
    redirect_to question_path(@question)
  end

  private

  def set_answer
    @answer =  @question.answers.find(params[:id])
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
