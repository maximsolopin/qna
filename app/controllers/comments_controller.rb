class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable
  after_action :publish_comment, only: :create

  respond_to :js, :json

  def create
    respond_with(@comment = @commentable.comments.create(comment_params.merge({ user: current_user })))
  end

  private

  def set_commentable
    @commentable = Question.find(params[:question_id]) if params[:question_id]
    @commentable ||= Answer.find(params[:answer_id])
  end

  def get_question_id
    question_id = @commentable.question_id if @commentable.kind_of?(Answer)
    question_id ||= @commentable.id
  end

  def get_publish_to_answers
    "/answers" if @commentable.kind_of?(Answer)
  end

  def publish_comment
    PrivatePub.publish_to "/questions/#{get_question_id}#{get_publish_to_answers}/comments", comment: render_to_string('comments/show.json.jbuilder') if @comment.valid?
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end