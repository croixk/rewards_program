class TransactionsSerializer
  include JSONAPI::Serializer

  def self.balance_return(transactions)
    transactions.each do |k, v|
      {
        "payer": k,
        "points": v
      }
    end
  end

  def self.spend_points(points)
    points.map do |k,v|
      {
        "payer": k,
        "points": v
      }
    end
  end
end
