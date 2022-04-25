class Transaction < ApplicationRecord
  validates_presence_of :payer, require: true
  validates_presence_of :points, require: true

  def Transaction.all_balances
    Transaction.group(:payer).sum(:points)
  end

  def Transaction.total_points
    Transaction.sum(:points)
  end

  def Transaction.get_payer_balance(payer)
    Transaction.where(payer: payer).sum(:points)
  end

  def Transaction.spend_points(points)
    if Transaction.total_points > points
      spend_record = Hash.new(0)
      transaction_counter = 0
      transactions = Transaction.order(:created_at)
      while points > 0
        oldest_transaction = transactions[transaction_counter]
        #this transaction covers cost 
        if oldest_transaction.points > points && Transaction.get_payer_balance(oldest_transaction.payer) > points
          spend_record[oldest_transaction.payer] -= points
          Transaction.create(payer: oldest_transaction.payer, points: -points)
          points = 0
          transaction_counter += 1

        # this transaction doesn't cover cost
        elsif oldest_transaction.points < points && oldest_transaction.points > 0 && Transaction.get_payer_balance(oldest_transaction.payer) > 0
          min_points = [oldest_transaction.points, Transaction.get_payer_balance(oldest_transaction.payer)].min
          spend_record[oldest_transaction.payer] -= min_points
          points -= min_points
          Transaction.create(payer: oldest_transaction.payer, points: -min_points)
          transaction_counter += 1

        else
          transaction_counter += 1
        end
      end
      return spend_record
    else
      return 0
    end
  end
end
