class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:new, :create]
  before_action :set_answer, only: [:edit, :destroy, :update, :set_best]
  before_action :check_author, only: [:destroy, :update, :set_best]

  include Voted
  
  def new
    @answer = Answer.new
  end

  def edit
  end

  def create
    @answer = @question.answers.new(answer_params.merge({ user: current_user }))

    PrivatePub.publish_to "/questions/#{@question.id}/answers", answer: render_to_string('answers/show.json.jbuilder') if @answer.save
  end

  def update
    @answer.update(answer_params)
  end

  def destroy
    @answer.destroy
  end

  def set_best
    @answer.set_best
    @question = @answer.question
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end

  def check_author
    if @answer.user.id != current_user.id
      flash[:alert] = 'Permision denied'
      redirect_to @answer.question
    end
  end
end
