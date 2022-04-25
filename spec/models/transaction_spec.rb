require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:payer)}
    it { should validate_presence_of(:points)}
  end

  describe 'Transaction.all_balances' do

    it 'mix positive and negative balances' do
      transaction_1 = Transaction.create!(payer: 'DANNON', points: 1000, created_at: "2020-11-02T14:00:00Z", updated_at: "2020-11-02T14:00:00Z")
      transaction_2 = Transaction.create!(payer: 'UNILEVER', points: 200, created_at: "2020-10-31T11:00:00Z", updated_at: "2020-10-31T11:00:00Z")
      transaction_3 = Transaction.create!(payer: 'DANNON', points: -200, created_at: "2020-10-31T15:00:00Z", updated_at: "2020-10-31T15:00:00Z")
      transaction_4 = Transaction.create!(payer: 'MILLER_COORS', points: 10000, created_at: "2020-11-01T14:00:00Z", updated_at: "2020-11-01T14:00:00Z")
      transaction_5 = Transaction.create!(payer: 'DANNON', points: 300, created_at: "2020-10-31T10:00:00Z", updated_at: "2020-10-31T10:00:00Z")

      result = Transaction.all_balances()
      expect(result.length).to eq(3)
      expect(result["DANNON"]).to eq(1100)
      expect(result["MILLER_COORS"]).to eq(10000)
      expect(result["UNILEVER"]).to eq(200)
    end

    it 'all negative balances' do
      transaction_1 = Transaction.create!(payer: 'DANNON', points: -1000, created_at: "2020-11-02T14:00:00Z", updated_at: "2020-11-02T14:00:00Z")
      transaction_2 = Transaction.create!(payer: 'UNILEVER', points: -200, created_at: "2020-10-31T11:00:00Z", updated_at: "2020-10-31T11:00:00Z")
      transaction_3 = Transaction.create!(payer: 'DANNON', points: -200, created_at: "2020-10-31T15:00:00Z", updated_at: "2020-10-31T15:00:00Z")
      transaction_4 = Transaction.create!(payer: 'MILLER_COORS', points: -10000, created_at: "2020-11-01T14:00:00Z", updated_at: "2020-11-01T14:00:00Z")
      transaction_5 = Transaction.create!(payer: 'DANNON', points: -300, created_at: "2020-10-31T10:00:00Z", updated_at: "2020-10-31T10:00:00Z")

      result = Transaction.all_balances()
      expect(result.length).to eq(3)
      expect(result["DANNON"]).to eq(-1500)
      expect(result["MILLER_COORS"]).to eq(-10000)
      expect(result["UNILEVER"]).to eq(-200)
    end

    it 'no balances' do
      expected_result = {}
      expect(Transaction.all_balances()).to eq(expected_result)
    end

  end

  describe 'Transaction.total_points' do
    it 'mix positive and negative' do
      transaction_1 = Transaction.create!(payer: 'DANNON', points: 1000, created_at: "2020-11-02T14:00:00Z", updated_at: "2020-11-02T14:00:00Z")
      transaction_2 = Transaction.create!(payer: 'UNILEVER', points: 200, created_at: "2020-10-31T11:00:00Z", updated_at: "2020-10-31T11:00:00Z")
      transaction_3 = Transaction.create!(payer: 'DANNON', points: -200, created_at: "2020-10-31T15:00:00Z", updated_at: "2020-10-31T15:00:00Z")
      transaction_4 = Transaction.create!(payer: 'MILLER_COORS', points: 10000, created_at: "2020-11-01T14:00:00Z", updated_at: "2020-11-01T14:00:00Z")
      transaction_5 = Transaction.create!(payer: 'DANNON', points: 300, created_at: "2020-10-31T10:00:00Z", updated_at: "2020-10-31T10:00:00Z")

      expect(Transaction.total_points()).to eq(11300)
    end

    it 'all points balance out, different orders (positive to negative, negative to positive)' do
      transaction_1 = Transaction.create!(payer: 'DANNON', points: 1000, created_at: "2020-11-02T14:00:00Z", updated_at: "2020-11-02T14:00:00Z")
      transaction_2 = Transaction.create!(payer: 'DANNON', points: -1000, created_at: "2020-10-31T15:00:00Z", updated_at: "2020-10-31T15:00:00Z")
      transaction_3 = Transaction.create!(payer: 'MILLER_COORS', points: -10000, created_at: "2020-11-01T14:00:00Z", updated_at: "2020-11-01T14:00:00Z")
      transaction_4 = Transaction.create!(payer: 'MILLER_COORS', points: 10000, created_at: "2020-10-31T10:00:00Z", updated_at: "2020-10-31T10:00:00Z")

      expect(Transaction.total_points()).to eq(0)
    end
  end



  describe 'Transaction.get_payer_balance' do
    it 'return balance for valid payer' do
      transaction_1 = Transaction.create!(payer: 'DANNON', points: 1000, created_at: "2020-11-02T14:00:00Z", updated_at: "2020-11-02T14:00:00Z")
      transaction_2 = Transaction.create!(payer: 'UNILEVER', points: 200, created_at: "2020-10-31T11:00:00Z", updated_at: "2020-10-31T11:00:00Z")
      transaction_3 = Transaction.create!(payer: 'DANNON', points: -200, created_at: "2020-10-31T15:00:00Z", updated_at: "2020-10-31T15:00:00Z")
      transaction_4 = Transaction.create!(payer: 'MILLER_COORS', points: 10000, created_at: "2020-11-01T14:00:00Z", updated_at: "2020-11-01T14:00:00Z")
      transaction_5 = Transaction.create!(payer: 'DANNON', points: 300, created_at: "2020-10-31T10:00:00Z", updated_at: "2020-10-31T10:00:00Z")

      expect(Transaction.get_payer_balance('DANNON')).to eq(1100)
    end

    it 'return balance for invalid payer - error handling' do
      transaction_1 = Transaction.create!(payer: 'DANNON', points: 1000, created_at: "2020-11-02T14:00:00Z", updated_at: "2020-11-02T14:00:00Z")
      transaction_2 = Transaction.create!(payer: 'UNILEVER', points: 200, created_at: "2020-10-31T11:00:00Z", updated_at: "2020-10-31T11:00:00Z")
      transaction_3 = Transaction.create!(payer: 'DANNON', points: -200, created_at: "2020-10-31T15:00:00Z", updated_at: "2020-10-31T15:00:00Z")
      transaction_4 = Transaction.create!(payer: 'MILLER_COORS', points: 10000, created_at: "2020-11-01T14:00:00Z", updated_at: "2020-11-01T14:00:00Z")
      transaction_5 = Transaction.create!(payer: 'DANNON', points: 300, created_at: "2020-10-31T10:00:00Z", updated_at: "2020-10-31T10:00:00Z")

      expect(Transaction.get_payer_balance('HEINEKEN')).to eq(0)
    end
  end

  describe 'Transaction.spend_points' do
    it 'valid spend points - payers all have positive totals' do
      transaction_1 = Transaction.create!(payer: 'DANNON', points: 1000, created_at: "2020-11-02T14:00:00Z", updated_at: "2020-11-02T14:00:00Z")
      transaction_2 = Transaction.create!(payer: 'UNILEVER', points: 200, created_at: "2020-10-31T11:00:00Z", updated_at: "2020-10-31T11:00:00Z")
      transaction_3 = Transaction.create!(payer: 'DANNON', points: -200, created_at: "2020-10-31T15:00:00Z", updated_at: "2020-10-31T15:00:00Z")
      transaction_4 = Transaction.create!(payer: 'MILLER_COORS', points: 10000, created_at: "2020-11-01T14:00:00Z", updated_at: "2020-11-01T14:00:00Z")
      transaction_5 = Transaction.create!(payer: 'DANNON', points: 300, created_at: "2020-10-31T10:00:00Z", updated_at: "2020-10-31T10:00:00Z")

      result = Transaction.spend_points(5000)
      expect(result.length).to eq(3)
      expect(result["DANNON"]).to eq(-300)
      expect(result["MILLER_COORS"]).to eq(-4500)
      expect(result["UNILEVER"]).to eq(-200)
    end

    it 'valid spend points - Dannon has a total of zero points' do
      transaction_1 = Transaction.create!(payer: 'DANNON', points: 1000, created_at: "2020-11-02T14:00:00Z", updated_at: "2020-11-02T14:00:00Z")
      transaction_2 = Transaction.create!(payer: 'UNILEVER', points: 200, created_at: "2020-10-31T11:00:00Z", updated_at: "2020-10-31T11:00:00Z")
      transaction_3 = Transaction.create!(payer: 'DANNON', points: -1000, created_at: "2020-10-31T15:00:00Z", updated_at: "2020-10-31T15:00:00Z")
      transaction_4 = Transaction.create!(payer: 'MILLER_COORS', points: 10000, created_at: "2020-11-01T14:00:00Z", updated_at: "2020-11-01T14:00:00Z")
      transaction_5 = Transaction.create!(payer: 'DANNON', points: 0, created_at: "2020-10-31T10:00:00Z", updated_at: "2020-10-31T10:00:00Z")

      result = Transaction.spend_points(5000)
      expect(result.length).to eq(2)
      expect(result["DANNON"]).to eq(0)
      expect(result["MILLER_COORS"]).to eq(-4800)
      expect(result["UNILEVER"]).to eq(-200)
    end

    it 'valid spend points (exactly the number of points available)' do
      transaction_1 = Transaction.create!(payer: 'DANNON', points: 1000, created_at: "2020-11-02T14:00:00Z", updated_at: "2020-11-02T14:00:00Z")
      transaction_2 = Transaction.create!(payer: 'UNILEVER', points: 200, created_at: "2020-10-31T11:00:00Z", updated_at: "2020-10-31T11:00:00Z")
      transaction_3 = Transaction.create!(payer: 'DANNON', points: -1000, created_at: "2020-10-31T15:00:00Z", updated_at: "2020-10-31T15:00:00Z")
      transaction_4 = Transaction.create!(payer: 'MILLER_COORS', points: 10000, created_at: "2020-11-01T14:00:00Z", updated_at: "2020-11-01T14:00:00Z")
      transaction_5 = Transaction.create!(payer: 'DANNON', points: 0, created_at: "2020-10-31T10:00:00Z", updated_at: "2020-10-31T10:00:00Z")

      result = Transaction.spend_points(10200)
      expect(result.length).to eq(2)
      expect(result["MILLER_COORS"]).to eq(-10000)
      expect(result["UNILEVER"]).to eq(-200)
    end

    it 'valid spend points - exactly enough points' do
      transaction_1 = Transaction.create!(payer: 'DANNON', points: 1, created_at: "2020-11-02T14:00:00Z", updated_at: "2020-11-02T14:00:00Z")
      transaction_2 = Transaction.create!(payer: 'UNILEVER', points: 1, created_at: "2020-10-31T11:00:00Z", updated_at: "2020-10-31T11:00:00Z")
      transaction_3 = Transaction.create!(payer: 'DANNON', points: 1, created_at: "2020-10-31T15:00:00Z", updated_at: "2020-10-31T15:00:00Z")
      transaction_4 = Transaction.create!(payer: 'MILLER_COORS', points: 1, created_at: "2020-11-01T14:00:00Z", updated_at: "2020-11-01T14:00:00Z")
      transaction_5 = Transaction.create!(payer: 'DANNON', points: 1, created_at: "2020-10-31T10:00:00Z", updated_at: "2020-10-31T10:00:00Z")

      result = Transaction.spend_points(5)
      expect(result.length).to eq(3)
      expect(result["MILLER_COORS"]).to eq(-1)
      expect(result["UNILEVER"]).to eq(-1)
      expect(result["DANNON"]).to eq(-3)
    end

    it 'invalid spend points - all transactions are zero' do
      transaction_1 = Transaction.create!(payer: 'DANNON', points: 0, created_at: "2020-11-02T14:00:00Z", updated_at: "2020-11-02T14:00:00Z")
      transaction_2 = Transaction.create!(payer: 'UNILEVER', points: 0, created_at: "2020-10-31T11:00:00Z", updated_at: "2020-10-31T11:00:00Z")
      transaction_3 = Transaction.create!(payer: 'DANNON', points: 0, created_at: "2020-10-31T15:00:00Z", updated_at: "2020-10-31T15:00:00Z")
      transaction_4 = Transaction.create!(payer: 'MILLER_COORS', points: 0, created_at: "2020-11-01T14:00:00Z", updated_at: "2020-11-01T14:00:00Z")
      transaction_5 = Transaction.create!(payer: 'DANNON', points: 0, created_at: "2020-10-31T10:00:00Z", updated_at: "2020-10-31T10:00:00Z")

      expected_result = 0
      expect(Transaction.spend_points(5000)).to eq(expected_result)
    end

    it 'invalid spend points - all transactions are one (not enough total points)' do
      transaction_1 = Transaction.create!(payer: 'DANNON', points: 1, created_at: "2020-11-02T14:00:00Z", updated_at: "2020-11-02T14:00:00Z")
      transaction_2 = Transaction.create!(payer: 'UNILEVER', points: 1, created_at: "2020-10-31T11:00:00Z", updated_at: "2020-10-31T11:00:00Z")
      transaction_3 = Transaction.create!(payer: 'DANNON', points: 1, created_at: "2020-10-31T15:00:00Z", updated_at: "2020-10-31T15:00:00Z")
      transaction_4 = Transaction.create!(payer: 'MILLER_COORS', points: 1, created_at: "2020-11-01T14:00:00Z", updated_at: "2020-11-01T14:00:00Z")
      transaction_5 = Transaction.create!(payer: 'DANNON', points: 1, created_at: "2020-10-31T10:00:00Z", updated_at: "2020-10-31T10:00:00Z")

      expected_result = 0
      expect(Transaction.spend_points(5000)).to eq(expected_result)
    end
  end
end
