# Rewards Program

## Background and Description

This application creates a collection of microservice endpoints for a brand-based rewards system, per the specifications outlined in the Fetch Rewards Backend Software Engineering coding exercise directions. These endpoints accept HTTP requets, and return responses.

To summarize, there are three routes. The specifics of these routes are outlined later in this document in greater detail:
1. Post a new transaction
- A transaction has a 'payer', a point value, and a timestamp. The payer is a brand associated with those points

2. Return all point balances (summed per payer)
- For example, if there were 5 transactions, but all for the same payer, this route would return one sum for that payer. If there were 5 transactions for 3 different payers in total, it would return 3 balances, one for each payer.

3. Spend points
- There are a few basic rules governing how points can be spent. The oldest points must be spent first, and a payer's points must never go negative in total (though transactions can have negative point values)



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

## Endpoints

### Post a new transaction

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

### Return all point balances

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

### Spend points

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

## Testing 
This code includes a variety of testing, both unit and feature, for all functionality that is provided. In general, I used my unit tests to ensure that methods work properly, and to explore method-specific edge cases, and my feature tests to ensure that the overall functionality is correct. To run all tests, you can enter ```bundle exec rspec``` in the terminal (after following the installation instructions above). In my testing, I tried to consider a wide variety of conditions and edge cases. Some examples of these edge cases are outlined below: 
- Transactions can have positive or negative points
- Oldest transaction for a payer has a positive number of points, but the total number of points for that payer is zero (these positive points can't be spent) 
- Total number of points across all transactions for all payers is zero (regardless of number of transactions) 
- Transaction is posted without critical information (name or payer) 
- Transaction is posted with a specific timestamp, versus without a timestamp, allowing the application to create a timestamp for the time that it was created (both of these are acceptable, and both should be allowed)
- A spend points request is made for a number of points that is equal to or greater to the number of total points available
