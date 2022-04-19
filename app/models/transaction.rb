class Transaction < ApplicationRecord
  validates_presence_of :payer, require: true
  validates_presence_of :points, require: true
end
