class SearchController < ApplicationController
  before_action :load_result

  def index
    authorize! :read, @result
    respond_with(@result)
  end

  private

  def load_result
    if params[:condition] == 'Everywhere'
      @result = ThinkingSphinx.search params[:query]
    else
      @result = ThinkingSphinx.search params[:query], classes: [params[:condition].classify.constantize]
    end
  end
end