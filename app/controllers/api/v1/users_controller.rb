class Api::V1::UsersController < ApplicationController

  def add_transaction
    transaction = Transaction.create(payer: params[:payer], points: params[:points])
    if transaction.save
      render status: 201
    else
      render status: 400
    end
  end
end
