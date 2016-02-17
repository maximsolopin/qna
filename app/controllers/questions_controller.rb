class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :edit, :update, :destroy, :subscribe, :unsubscribe]
  # before_action :check_author, only: [:destroy, :update]
  after_action :publish_question, only: :create

  include Voted

  respond_to :json

  authorize_resource

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with(@answer = @question.answers.build)
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    @question.update(question_params)
    respond_with(@question)
  end

  def destroy
    respond_with(@question.destroy)
  end

  # def subscribe
  #   @question.subscribe(current_user)
  #   flash[:notice] = "You've successfully subscribed to the question"
  #   redirect_to @question
  # end
  #
  # def unsubscribe
  #   @question.unsubscribe(current_user)
  #   flash[:notice] = "You've successfully unsubscribed"
  #   redirect_to @question
  # end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def check_author
    if @question.user.id != current_user.id
      flash[:alert] = 'Permision denied'
      redirect_to @question
    end
  end

  def publish_question
    PrivatePub.publish_to "/questions", question: render_to_string('questions/index.json.jbuilder') if @question.valid?
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end
end
