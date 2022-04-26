# Rewards Program

## Background and Description

This is an API application that creates a collection of endpoints for a brand-based rewards system, to be part of a microservice oriented architecture application per the specifications outlined in the Fetch Rewards Backend Software Engineering coding exercise directions. 

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

6. The endpoints can now be utilized as outlined below. 

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
- A timestamp will be created automatically unless provided 
- Transaction point values can be either positive or negative - negative transactions are typically used to spend points from a payer account (outlined below in more detail) 

Here is a screenshot of an example of this request in Postman:

![Screen Shot 2022-04-25 at 7 35 41 PM](https://user-images.githubusercontent.com/20864043/165201660-23dc104c-1f01-45d7-b27f-eae63895d4cb.png)


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

Here is a screenshot of this request in Postman - it shows the balance after the Postman add transaction above.

![Screen Shot 2022-04-25 at 7 35 50 PM](https://user-images.githubusercontent.com/20864043/165201918-21545d73-6a08-480d-b384-552a2957a9a3.png)


### Spend points

This route receives an argument for the number of points that need to be spent, and spends those points. There are a few basic rules governing how points can be spent. The oldest points must be spent first, and a payer's points must never go negative in total (though transactions can have negative point values). The total points available also can't go negative - only availabe points can be spent. The logic of the spend points method ensures that these rules are followed. 

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

Here is a screenshot from Postman after a spend request to spend 2000 points - it shows how the 2000 points were spent from the Coca-Cola account 

![Screen Shot 2022-04-25 at 7 35 59 PM](https://user-images.githubusercontent.com/20864043/165202148-7569d1e1-23e7-47df-bc46-36cd09ee7518.png)



Here is another balance request, after the spend request - it shows that the balance was updated for Coca-Cola, from 6000 to 4000 

![Screen Shot 2022-04-25 at 7 36 10 PM](https://user-images.githubusercontent.com/20864043/165202185-f8d5a4ce-ea93-4ebc-b6cb-e69a0c7595cc.png)



Here is one more screenshot, for a spend request for 5000 points. It shows that this returns a 400 status code, since there aren't 5000 points available after the first 2000 are spent. 

![Screen Shot 2022-04-25 at 7 36 27 PM](https://user-images.githubusercontent.com/20864043/165202304-471ba699-c0cf-40d8-9d39-69fdbf5a22bf.png)



## Design Decisions 
I made the decision to complete this challenge as a Ruby on Rails API application. I created a database table in Rails using PostgreSQL for the transactions, storing each new transaction in the table, and used Active Record to efficiently handle my database queries where possible. 

When points are spent, my spend points method created new transactions to store this information in the transaction record, instead of updating existing transactions, since my assumption was that this would be more suitable for an accounting team than updating existing transactions. 

My spend points method featured some Ruby logic in addition to Active Record queries and calls to helper methods that utilize Active Record. The logic for the spend points method was more involved than the other methods, but I designed this method to still run as efficiently as possible as the number of transactions grew. In one example of this, I create a list of transactions in chronological order and store this once when the spend_points method is called, and iterate through this list of transactions as needed, instead of repeatedly querying the database to find the next-oldest transaction. I also tested this method thoroughly to ensure that it handles a wide variety of different scenarios properly. 

Finally, I moved as much logic as possible to the model, and used a serializer to format the reponses from my routes. 

## Testing 
This code includes a variety of testing, both unit and request, for all functionality that is provided. In general, I used my unit tests to ensure that methods work properly, and to explore method-specific edge cases, and my request tests to ensure that the overall functionality is correct, and that my HTTP responses are correct. To run all tests, you can enter ```bundle exec rspec``` in the terminal (after following the installation instructions above). In my testing, I tried to consider a wide variety of conditions and edge cases. Some examples of these edge cases are outlined below: 
- Transactions can have positive or negative points - however, a negative transaction that is created should never result in a negative number of total points for a payer
- If the oldest transaction for a payer has a positive number of points, but the total number of points for that payer is zero, these positive points can't be spent
- If the total number of points across all transactions for all payers is zero, points can't be spent
- If a transaction is posted without critical information (name or payer), this transaction should not be stored to the database, and a status code should be returned that signifies that the post was unsuccessful
- Transactions can be posted with a specific timestamp, or without a timestamp. If a transaction is posted without a timestamp, it should store a created at value when the transaction is created
- A spend points request is made for a number of points that is greater than the number of total points available, the request should not be completed

My testing addressess all these edge cases, among others, to ensure that the application functions as intended. 
