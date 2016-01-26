class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_answer, only: [:edit, :destroy, :update, :set_best]
  # before_action :check_author, only: [:destroy, :update, :set_best]
  after_action :publish_answer, only: :create

  include Voted

  respond_to :js, :json

  authorize_resource

  def new
    respond_with(@answer = Answer.new)
  end

  def create
    @question = Question.find(params[:question_id])
    respond_with(@answer = @question.answers.create(answer_params.merge({ user: current_user })))
  end

  def update
    @answer.update(answer_params)
    respond_with(@answer)
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def set_best
    @answer.set_best
    @question = @answer.question
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def publish_answer
    PrivatePub.publish_to "/questions/#{@question.id}/answers", answer: render_to_string('answers/show.json.jbuilder') if @answer.valid?
  end

  def check_author
    if @answer.user.id != current_user.id
      flash[:alert] = 'Permision denied'
      redirect_to @answer.question
    end
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end
end
