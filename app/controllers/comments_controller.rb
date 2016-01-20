class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user

    if @commentable.kind_of?(Answer)
      publish_to_answers = "/answers"
      question_id = @commentable.question_id
    else
      question_id = @commentable.id
    end

    PrivatePub.publish_to "/questions/#{question_id}#{publish_to_answers}/comments", comment: render_to_string('comments/show.json.jbuilder') if @comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def get_commentable_name
    @commentable.class.name.underscore
  end

  def set_commentable
    if params[:question_id]
      @commentable = Question.find(params[:question_id])
    elsif params[:answer_id]
      @commentable = Answer.find(params[:answer_id])
    end
  end
end