class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question

  def create
    authorize! :create, @question

    if !@question.subscribed?(current_user)
      @question.subscriptions.create(user: current_user)
      flash[:notice] = "You've successfully subscribed to the question"
    end

    redirect_to @question
  end

  def destroy
    authorize! :destroy, @question

    @subscription = @question.subscriptions.find_by(user: current_user)

    if @subscription
      @subscription.destroy if @subscription
      flash[:notice] = "You've successfully unsubscribed"
    end

    redirect_to @question
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end
end
