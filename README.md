# Recipe Costs API

Professional kitchens need to know their recipe costs to profitably price their food. Recipe Costs makes it easy to determine both the full cost and cost per serving of each recipe. 

This repository houses the Rails API, supplying data to the [JavaScript frontend interface](https://github.com/aparkening/recipe_costs_frontend). 

## Installation

1. Clone this repo.
2. Install dependences:
```
    $ bundle install
```
3. Create database structure:
```
    $ rails db:create
    $ rails db:migrate
```
4. Run web server:
```
    $ rails s
```
5. Navigate to `localhost:3000` in your browser.

## Usage

- Add your own data via command line by using `rails c`.

- Use test data by running the seed file:

```
    $ rails db:seed
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/aparkening/recipe_costs_api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Tea Tastes project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/aparkening/recipe_costs_api/blob/master/CODE_OF_CONDUCT.md).
