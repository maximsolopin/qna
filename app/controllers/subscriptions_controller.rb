class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question

  authorize_resource

  def create
    @question.subscriptions.create(user: current_user) unless @question.subscribed?(current_user)
    flash[:notice] = "You've successfully subscribed to the question"
    redirect_to @question
  end

  def destroy
    @subscription = @question.subscriptions.find_by(user: current_user)
    @subscription.destroy if @subscription
    flash[:notice] = "You've successfully unsubscribed"
    redirect_to @question
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end
end
