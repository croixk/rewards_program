require 'rails_helper'

RSpec.describe 'Return balances route' do
  it 'returns summed balances if balances exist' do
    transaction_1 = Transaction.create!(payer: 'DANNON', points: 1000, created_at: "2020-11-02T14:00:00Z", updated_at: "2020-11-02T14:00:00Z")
    transaction_2 = Transaction.create!(payer: 'UNILEVER', points: 200, created_at: "2020-10-31T11:00:00Z", updated_at: "2020-10-31T11:00:00Z")
    transaction_3 = Transaction.create!(payer: 'DANNON', points: -200, created_at: "2020-10-31T15:00:00Z", updated_at: "2020-10-31T15:00:00Z")
    transaction_4 = Transaction.create!(payer: 'MILLER_COORS', points: 10000, created_at: "2020-11-01T14:00:00Z", updated_at: "2020-11-01T14:00:00Z")
    transaction_5 = Transaction.create!(payer: 'DANNON', points: 300, created_at: "2020-10-31T10:00:00Z", updated_at: "2020-10-31T10:00:00Z")

    get '/api/v1/transactions/balances'

    data = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(data).to be_a(Hash)
    expect(response.status).to eq(200)
    expect(data.length).to eq(3)
    expect(data[:MILLER_COORS]).to eq(10000)
    expect(data[:UNILEVER]).to eq(200)
    expect(data[:DANNON]).to eq(1100)
  end

  it 'returns empty array if no balances exist' do
    get '/api/v1/transactions/balances'

    expected_response = {}

    data = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(response.status).to eq(200)
    expect(data).to eq(expected_response)
  end

end
