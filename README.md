# dozer

[![Build Status](https://secure.travis-ci.org/helloworld1812/dozer.svg)](http://travis-ci.org/helloworld1812/dozer)

Inspired by a java library `dozer`, this ruby gem is used to convert hash from one schema to another schema. It provides a convenient way to mapping data from one system to another systems.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dozer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dozer

## Usage

### step1: define a mapper class as a strategy.

- include the module `Dozer::Mapperable`
- use `mapping` method to mapping the data schema between source(:from) and destination(:to)

```
# adp_mapper.rb
class AdpMapper
  include Dozer::Mapperable

  mapping from: 'adp/firstName', to: :first_name
  mapping from: 'adp/lastName',  to: :last_name
  mapping from: 'adp/gender',    to: :gender
end
```
 
If you have multiple integrations, you can define a set of mapper classes in your Rails application folder.

```
mappers
    - indeed_mapper.rb
    - salesforce_mapper.rb
    - adp_mapper.rb

```

### step2: convert the data from source to destination using this interface.

```
data = { 'adp/firstName' => 'Ryan', 'adp/lastName' => 'Lyu' }
Dozer.map(data, AdpMapper)
=> {first_name: 'Ryan', last_name: 'Lyu'}
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dozer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Dozer project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/dozer/blob/master/CODE_OF_CONDUCT.md).
