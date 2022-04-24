class Api::V1::TransactionsController < ApplicationController

  def add_transaction
    transaction = Transaction.create(payer: params[:payer], points: params[:points])
    if transaction.save
      render status: 201
    else
      render status: 400
    end
  end

  def balances
    transactions = Transaction.all_balances
    render json: TransactionsSerializer.balance_return(transactions)
  end
end
