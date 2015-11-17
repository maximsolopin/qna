class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:new, :create]
  before_action :set_answer, only: [:edit, :destroy, :update]
  before_action :check_author, only: [:destroy, :update]

  def new
    @answer = Answer.new
  end

  def edit
  end

  def create
    redirect_to @answer.question if current_user.nil?

    @answer = @question.answers.new(answer_params.merge({ user: current_user }))

    if @answer.save
      redirect_to @question
    else
      render :new
    end
  end

  def update
    if @answer.update(answer_params)
      flash[:notice] = 'Answer updated'
      redirect_to @answer.question
    else
      render :edit
    end
  end

  def destroy
    @answer.destroy
    flash[:notice] = 'Answer deleted'
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

  def check_author
    if @answer.user.id != current_user.id
      flash[:alert] = 'Permision denied'
      redirect_to @answer.question
    end
  end
end
