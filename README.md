# Restoman API

## Ruby version
Ruby 2.6.6

## System dependencies
MySQL 5.7
Redis 6.0.5-alpine

# Installing Ruby
```
rvm pkg install openssl
rvm install "ruby-2.7.2" --with-openssl-dir=$HOME/.rvm/usr
```

# Starting the dependency services
`$ docker-compose up`

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
The Swagger API doc is available at [http://localhost:3000/index.html](http://localhost:3000/index.html)

## How to run the test suite
`$ rails test test/`
