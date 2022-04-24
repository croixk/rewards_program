require 'rails_helper'

RSpec.describe 'Transactions' do
  it 'posts successfully' do
    transaction = Transaction.create(payer: 'DANNON', points: 1000, created_at: "2020-11-02T14:00:00Z", updated_at: "2020-11-02T14:00:00Z")
    post '/api/v1/transactions/add_transaction', params: transaction, as: :json
    expect(response).to be_successful
    expect(status).to eq(201)
  end

  it 'does not post if it is missing a field' do
    transaction = Transaction.create(payer: 'DANNON', created_at: "2020-11-02T14:00:00Z", updated_at: "2020-11-02T14:00:00Z")
    post '/api/v1/transactions/add_transaction', params: transaction, as: :json
    expect(response).to_not be_successful
    expect(status).to eq(400)
  end
end
