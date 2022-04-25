# Rewards Program

## Background and Description

This application creates a rewards program, per the specifications outlined in the Fetch Rewards Backend Software Engineering coding exercise directions.

To summarize, there are three routes, to:
1. Post a new transaction
- A transaction has a 'payer', a point value, and a timestamp. The payer is a brand associated with those points

2. Return all point balances (summed per payer)
- For example, if there were 5 transactions, but all for the same payer, this route would return one sum for that payer. If there were 5 transactions for 3 different payers in total, it would return 3 balances, one for each payer.

3. Spend points
- There are a few basic rules governing how points can be spent. The oldest points must be spent first, and a payer's points must never go negative in total (though transactions can have negative point values)



## Requirements and Setup
### Ruby/Rails
- Ruby 2.7.2
- Rails 5.2.6.3
### Setup
1. Clone this repo. On your local machine, open the terminal and enter the following command:

```
$ git clone git@github.com:croixk/rewards_program.git
```

2. You can now enter the project directory ```$ cd rewards_program```

3. Now, install the required gems using ```$ bundle install```

4. Run database migrations with ```$ rails db:{drop,create,migrate,seed}```

5. Start the local server ```$ rails s```

6. The routes can now be tested in Postman

## Routes and Expected Response

### Post a new transaction

Route: post '/api/v1/transactions/add_transaction'

Post body: 
```
{ "payer": "COCA-COLA", "points": 6000, "timestamp": "2020-11-02T14:00:00Z" }
```

Response:
- 201 status code if transaction posts successfully
- 404 status code if transaction does not post successfully

### Return all point balances

Route: get '/api/v1/transactions/balances'

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

Route: post '/api/v1/transactions/spend_points'

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
