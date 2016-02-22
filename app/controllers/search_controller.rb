class SearchController < ApplicationController
  before_action :load_result

  def index
    authorize! :read, @result
    respond_with(@result)
  end

  private

  def load_result
    search = Search.new(params[:query], params[:condition])
    if search.valid?
      @result = search.search
    else
      flash[:error] = search.errors.full_messages
    end
  end
end