class SearchController < ApplicationController
  before_action :load_result

  def index
    authorize! :read, @result
    respond_with(@result)
  end

  private

  def load_result
    search = Search.new(params[:query], params[:condition])
    @result = search.search

    flash[:error] = search.errors.full_messages unless search.valid?
  end
end