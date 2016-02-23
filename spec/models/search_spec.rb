require 'rails_helper'

RSpec.describe Search, type: :model do
  it 'Invalid query condition' do
    search = Search.new('Test query', 'Admins')
    expect(search).to be_invalid
    expect(search.errors[:condition].size).to eq(1)
  end

  describe 'should searching result' do
    %w(Questions Answers Comments Users).each do |condition|
      it "in #{condition}" do
        expect(ThinkingSphinx).to receive(:search).with('Test query', {classes: ["#{condition}".classify.constantize]})
        search = Search.new('Test query', condition)
        search.search
      end
    end
  end

  it 'should searching result in Everywhere' do
    expect(ThinkingSphinx).to receive(:search).with('Test query', {classes: [nil]})
    search = Search.new 'Test query', 'Everywhere'
    search.search
  end

  it 'should not search with invalid query' do
    expect(ThinkingSphinx).to_not receive(:search)
    search = Search.new '', 'Everywhere'
    search.search
  end
end
