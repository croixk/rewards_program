class Api::V1::TransactionsController < ApplicationController

  def add_transaction
    transaction = Transaction.create(payer: params[:payer], points: params[:points])
    if transaction.save
      render status: 200
    else
      render status: 400
    end
  end

  def balances
    transactions = Transaction.all_balances
    render json: TransactionsSerializer.balance_return(transactions)
  end

  def spend_points
    spend_points = Transaction.spend_points(params[:points])
    if spend_points != 0
      render json: TransactionsSerializer.spend_points(spend_points)
    else
      render status: 400
    end
  end
end
