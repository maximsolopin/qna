class Search
  include ActiveModel::Validations

  attr_accessor :query, :condition

  validates :query, presence: true
  validate :include_in_conditions

  CONDITIONS = %w(Everywhere Questions Answers Comments Users)

  def initialize(query, condition)
    @query = query
    @condition = condition
  end

  def search
    classes = @condition == 'Everywhere' ? nil : @condition.classify.constantize
    ThinkingSphinx.search Riddle::Query.escape(@query), classes: [classes]
  end

  private

  def include_in_conditions
    errors.add(:condition, 'Invalid query condition') unless CONDITIONS.include? @condition
  end
end
