# Restoman API

## Ruby version
Ruby 2.6.6

## System dependencies
MySQL 5.7

## Database creation
`$ rails db:create db:migrate`

## Database initialization
`$ rails db:seed`

## Mailer setup
Provide credentials of Gmail account in the following environment variables
- `email`
- `password`

## Running the app
```
$ bundle install
$ rails s
```

## API documentation
The Swagger API doc JSON is rendered at the endpoint `/api-docs`.

To view the docs with [Swagger UI](https://swagger.io/tools/swagger-ui/),
- Start the app server - `restoman-api $ rails s`
- Go to [https://petstore.swagger.io](https://petstore.swagger.io)
- Point it to [http://localhost:3000/api-docs](http://localhost:3000/api-docs)

## How to run the test suite
`$ rails test test/`
