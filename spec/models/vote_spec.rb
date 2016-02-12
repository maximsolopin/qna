require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:votable) }

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :votable_id }
  it { should validate_presence_of :value }

  it_behaves_like 'Votable', 'Answer'
  it_behaves_like 'Votable', 'Question'
end