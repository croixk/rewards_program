require 'rails_helper'

RSpec.describe 'Spend points' do
  it 'have enough points - return remaining points correctly after spending points' do
    transaction_1 = Transaction.create!(payer: 'DANNON', points: 1000, created_at: "2020-11-02T14:00:00Z", updated_at: "2020-11-02T14:00:00Z")
    transaction_2 = Transaction.create!(payer: 'UNILEVER', points: 200, created_at: "2020-10-31T11:00:00Z", updated_at: "2020-10-31T11:00:00Z")
    transaction_3 = Transaction.create!(payer: 'DANNON', points: -200, created_at: "2020-10-31T15:00:00Z", updated_at: "2020-10-31T15:00:00Z")
    transaction_4 = Transaction.create!(payer: 'MILLER_COORS', points: 10000, created_at: "2020-11-01T14:00:00Z", updated_at: "2020-11-01T14:00:00Z")
    transaction_5 = Transaction.create!(payer: 'DANNON', points: 300, created_at: "2020-10-31T10:00:00Z", updated_at: "2020-10-31T10:00:00Z")

    payment = {"points": 5000}

    post '/api/v1/transactions/spend_points', params: payment, as: :json

    data = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_successful
    expect(status).to eq(200)
    expect(Transaction.all.count).to eq(8)

    get '/api/v1/transactions/balances'

    data = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(data).to be_a(Hash)
    expect(response.status).to eq(200)
    expect(data.length).to eq(3)
    expect(data[:MILLER_COORS]).to eq(5500)
    expect(data[:UNILEVER]).to eq(0)
    expect(data[:DANNON]).to eq(800)
  end

  it 'does not have enough points - return status 404' do
    transaction_1 = Transaction.create!(payer: 'DANNON', points: 1000, created_at: "2020-11-02T14:00:00Z", updated_at: "2020-11-02T14:00:00Z")
    transaction_2 = Transaction.create!(payer: 'UNILEVER', points: 200, created_at: "2020-10-31T11:00:00Z", updated_at: "2020-10-31T11:00:00Z")
    transaction_3 = Transaction.create!(payer: 'DANNON', points: -200, created_at: "2020-10-31T15:00:00Z", updated_at: "2020-10-31T15:00:00Z")
    transaction_4 = Transaction.create!(payer: 'MILLER_COORS', points: 10000, created_at: "2020-11-01T14:00:00Z", updated_at: "2020-11-01T14:00:00Z")
    transaction_5 = Transaction.create!(payer: 'DANNON', points: 300, created_at: "2020-10-31T10:00:00Z", updated_at: "2020-10-31T10:00:00Z")

    payment = {"points": 20000}

    post '/api/v1/transactions/spend_points', params: payment, as: :json

    expect(response).to_not be_successful
    expect(status).to eq(400)

    get '/api/v1/transactions/balances'

    data = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(data.length).to eq(3)
    expect(data).to be_a(Hash)
    expect(response.status).to eq(200)
    expect(data[:MILLER_COORS]).to eq(10000)
    expect(data[:UNILEVER]).to eq(200)
    expect(data[:DANNON]).to eq(1100)
  end
end
