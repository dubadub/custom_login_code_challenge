# Code challenge for CustomLogin

## Setup

Run `bundle` and then `rails db:migrate`.

## Run tests

Run `rspec`.

## Run server

Run `rails s`.

## Seed database with user

Run `rails db:seed`. It will create a user with handle "captain" and password "hello".

## Original Spec

- [x] Create a basic Rails application using a SQL database.

- [x] The application should provide a user model that incorporates elements such as a unique user 'handle' (their username), password and a login failure count.

- [x] Provide a HTML based UI that provides for a user login (users can be created via direct access to the database only, no need for a user sign up).

- [x] Upon successful completion, the user will be presented with a basic log out option (nothing fancy needed here) so that the process can be attempted repeatedly.

- [x] The code should account for login failures and lock the user account (i.e. prevent log in) after 3 consecutive fails (reset the failure count upon a successful login).

- [x] Include unit tests for the models and controllers created.

- [x] Do not use libraries or features that already encapsulate a lot of this process (e.g. devise or has_secure_password).
