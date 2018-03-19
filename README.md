Rails Distance API
=======================

Hello!

This is an API that give the user the possibility to save routes between two geographic points. It also give one way to calculate the cost between two of these points, based on the distance previously saved.
This API use the smaller route to determine the cost of the travel and can use the waypoints previously setted to determine the lower cost.

## Getting Started

These instructions will teach how to set-up and run the API. This will also do some considerations about the way that this has been developed and the reasons for that.

### Prerequisites

To run this API, first of all you need to have "Ruby" installed in your system.

If you are running Ubuntu, you could get Ruby using apt.
```
apt-get install ruby
```

An Other way to install Ruby is using a Package Manager, like `asdf`.
You could see how to install asdf [here](https://github.com/asdf-vm/asdf) and how to install ruby from asdf [here](https://github.com/asdf-vm/asdf-ruby).


Regardless of the way Ruby is installed, you'll need to install Rails. For that you need to run
```
gem install rails
```

After that you're able to set-up and run the application

### Instalation

To set-up the application, first of all you need to clone the application in a path on your system.
The repository of application is [here](https://github.com/cirrastda/backend-code-challenge).

You can download the source code from the repository or clone it from the command line. For example
```
git clone https://github.com/cirrastda/backend-code-challenge .
```

After clone (or download) your application, you need, in the application path, run the database set-up. For that you should run
```
rails db:migrate
```

After that, you need to run your application. For that you need to run
```
rails server
```

## Running the API

### Distance API

To run the Distance API, you need to make a post request to the Server link, passing the *origin*, *destination* and *distance* in a text/plain way. For example:
```
wget -S http://localhost:3000/distance -O response.json --post-data 'LOC1 LOC2 10'
```

This will generate a response file called `response.json` with the result of the request.

The response is created with type `application/json`, with the attributes `status` and `message`. For example:
```
{"status":"ok","mensagem":"Success"}
```
When the `status` attribute indicates if the request is sucessfull or not and the `message` attribute indicate the return message (or error message in case of error).

There are two possible status returned in the response.
- `ok`: Indicate a successfull request
- `error`: Indicate an error in the request. This status is accompanied by a message indicating the error.

In case of success, the distance between the two passed points will be setted-up if it doesn't exists or update if it already exists.

### Cost API

The cost API will return the smallest cost of the travel between the two passed points, considering the weight of the weight of the load, passed to the API.
To determine the smallest cost of the travel, the API will determine the shortest distance between the points passed to the API, independent os the number of waypoints.

To calculate the cost os the travel, you need to call the API passing the *origin*, *destination* and the *weight* in the query string, doing a GET request.
For example:
```
wget -S -O cost.txt 'http://localhost:3000/cost?origin=LOC1&destination=LOC2&weight=10'
```

This will generate a response file called `cost.txt` with the result of the request, that is set with type `plain/text`.
If the route could be found, the result will be the cost of the travel, using the shortest distance, following the formula: `cost = distance * weight * 0.15`.
If the route couldn't be determined, the API will return the message `No Path Found between Origin and Destination`
Also, if Origin or Destination are not set in the database, the request will return `Origin not found` or `Destination not found` according to the given error.

### Alternative ways

There are other ways to call the API, like [cUrl](https://github.com/curl/curl) or using a REST Client like [Postman](https://www.getpostman.com/).
Any of these have it's own way to make the call. These could be check acessing the tool documentation. 


## Run Tests

This API has been developed with Unit Test funcionalities.
There are two Model tests (following the two models used to develop the API) and two Controller tests, following the two API Interfaces developed.

To run the Model Tests, you need to run
```
rails test test/models
```

Also, to run Controllet Tests you need to run
```
rails test test/controllers
```

If you need to run all tests, you could run
```
rails test
```

## Considerations

The solution has been developed using Rails, due to it's easiest way to develop a simple API. It also used *SQLite* as database due to it's easy to set-up.

It has been created two database tables. The first one is to record the Places passed from user, normalizing the Places. The other one, with two foreign keys to the *Place* table is to record the distance between two places.

To record the distances, the controller look for the places passed as parameters and, if they don't exist (or one of that), they are created in database, returning it's generated ids to be recorded. Id they already exists, the controller search and return their's ids.
The *distances* controller is subdivided in 3 actions. The main one and two auxiliary, that are privates. This was made to make the code easier to understand and to be more organized.

The *costs* controller also has three actions. The main action, called *process* and two auxiliary. One to validate the entry parameters and other to calculate the Weight using the parameters. The second one also check if the passed origin and destinaion exists in database, before look to the route.

To determine the shortest route between two places, it's been used a recursive query, following the full path of the routes that starts with the origin point and determining what of that ends with the destination point, sorting then from distance and returning the first one.
This solution was made because it needs less iterations, making that less costable to the server.

The tests was developed using some scenarios identifieds during the developing.