require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:payer)}
    it { should validate_presence_of(:points)}
    it { should validate_presence_of(:created_at)}
    it { should validate_presence_of(:updated_at)}
  end
end
