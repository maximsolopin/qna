require 'rails_helper'

RSpec.describe Search, type: :model do
  it 'Invalid query condition' do
    search = Search.new('Test query', 'Admins')
    expect(search).to be_invalid
    expect(search.errors[:condition].size).to eq(1)
  end
end
