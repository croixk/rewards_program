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
end
