# Rewards Program

## Background and Description

This application creates a collection of microservice endpoints for a brand-based rewards system, per the specifications outlined in the Fetch Rewards Backend Software Engineering coding exercise directions. 

## Requirements and Setup
### Ruby/Rails
- Ruby 2.7.2
- Rails 5.2.7
### Setup
1. Clone this repo. On your local machine, open the terminal and enter the following command:

```
$ git clone git@github.com:croixk/rewards_program.git
```

2. You can now enter the project directory ```$ cd rewards_program```

3. Now, install the required gems using ```$ bundle install```

4. Run database migrations with ```$ rails db:{drop,create,migrate,seed}```

5. Start the local server ```$ rails s```

6. The endpoints can now be utilized as is outlined below. 

## Routes

### Post a new transaction

This transaction creates a new transaction in the database, with a 'payer', a point value, and a timestamp. The payer is a brand associated with those points.

Route: POST '/api/v1/transactions/add_transaction'

Post body: 
```
{ "payer": "COCA-COLA", "points": 6000, "timestamp": "2020-11-02T14:00:00Z" }
```

Response:
- 201 status code if transaction posts successfully
- 404 status code if transaction does not post successfully
- For transaction to post successfully, both a "payer" (brand), and a number of points must be provided
- A timestamp will be created automatically unless otherwise provided 
- Transaction point values can be either positive or negative - negative transactions are used to spend points from a payer account (outlined below in more detail) 

### Return all point balances

This route returns each payer with the point total for that payer. For example, if there were 5 transactions, but all for the same payer, this route would return one sum for that payer. If there were 5 transactions for 3 different payers in total, it would return 3 balances, one for each payer.

Route: GET '/api/v1/transactions/balances'

Response:
- 200 status code

Response body:
```
  {
    "DANNON": 1000,
    "UNILEVER": 0,
    "MILLER COORS": 5300
  }
```

For this example response, you don't know how many total transactions there are, just that they sum to the point values shown. There would need to be at least 3 total transactions, but could be many more transactions. 

### Spend points

This route receives an argument for the number of points that need to be spent, and spends those points. There are a few basic rules governing how points can be spent. The oldest points must be spent first, and a payer's points must never go negative in total (though transactions can have negative point values)

Route: POST '/api/v1/transactions/spend_points'

Response:
- 200 status code if successful
- 400 status code if not successful

Reponse body: 
```
  [
    { "payer": "DANNON", "points": -100 },
    { "payer": "UNILEVER", "points": -200 },
    { "payer": "MILLER_COORS", "points": -4700 }
  ]
```

## Design Decisions 
I made the decision to complete this challenge as a Ruby on Rails API application. I created a database table in Rails for the transactions, storing each new transaction as an item in the table, and used Active Record to efficiently handle my database queries, where possible. 

When points are spent, my spend points method created new transactions to store this information in the transaction record, instead of updating existing transactions, since my assumption was that this would better fulfill the project intent, and would be more suitable for an accounting team. 

My spend points method featured some Ruby logic in addition to Active Record queries and calls to helper methods that utilize Active Record. The logic for the spend points method was more involved than the other methods, but I designed this method to still run as efficiently as possible and to limit time complexity as the number of transactions grew. In one example of this, I create a list of transactions in chronological order and store this once when the spend_points method is called, and iterate through this list of transactions as needed, instead of repeatedly querying the database to find the next-oldest transaction. I also tested this method thoroughly to ensure that it handles a wide variety of different scenarios properly. 

## Testing 
This code includes a variety of testing, both unit and feature, for all functionality that is provided. In general, I used my unit tests to ensure that methods work properly, and to explore method-specific edge cases, and my feature tests to ensure that the overall functionality is correct. To run all tests, you can enter ```bundle exec rspec``` in the terminal (after following the installation instructions above). In my testing, I tried to consider a wide variety of conditions and edge cases. Some examples of these edge cases are outlined below: 
- Transactions can have positive or negative points - however, a negative transaction that is created should never result in a negative number of total points for a payer
- If the oldest transaction for a payer has a positive number of points, but the total number of points for that payer is zero , these positive points can't be spent
- If the total number of points across all transactions for all payers is zero, points can't be spent
- If a transaction is posted without critical information (name or payer), this transaction should not be stored to the database, and a status code should be returned that signifies that the post was unsuccessful
- Transactions can be posted with a specific timestamp, or without a timestamp. If a transaction is posted without a timestamp, it should store a created at value when the transaction is created
- A spend points request is made for a number of points that is equal to or greater to the number of total points available

My testing addressess all these edge cases, among others, to ensure that the application functions as intended. 
