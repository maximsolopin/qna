require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should validate_presence_of :subscription }
  it { should validate_presence_of :subscribers }

  it { should belong_to :subscription }
  it { should belong_to :subscribers }
end
