class Transaction < ApplicationRecord
  validates_presence_of :payer, require: true
  validates_presence_of :points, require: true
  validates_presence_of :created_at, require: true
  validates_presence_of :updated_at, require: true 


end
