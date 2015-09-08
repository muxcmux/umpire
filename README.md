# Umpire

[![Build Status](https://snap-ci.com/muxcmux/umpire/branch/master/build_image)](https://snap-ci.com/muxcmux/umpire/branch/master)

Umpire is a very lightweight authorization lib that uses policy classes to define rules

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'umpire'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install umpire

## Usage

Umpire consists of a base policy class that you need to extend and a helper that you can use in your app.
Because it's doesn't depend on rails, you need to include the Umpire helper in your `ApplicationHelper`
and your `ApplicationController` or whatever other class you might need to use it in:

    include Umpire::AuthHelper

I use that in a rails lib, so by default the lib uses a `current_user` method to get the subject from,
but if you don't have it - no worries, you can still pas a subject on your own.

Let's make a simple Policy class and use it in a rails view:

```ruby
class SchoolPolicy < Umpire::Policy
  # the only method you need to overwrite
  # return all the allowed actions here
  # @subject is the subject (current_user) by default
  # and the object is @object - in this exapmle it could be a
  def rules
    allowed = [:go_to_school]
    allowed << :take_cs_201  @subject.has_taken(:cs_101)
    allowed
  end
end
```

You can now use the policy class with the helper like this:
```erb
<%= render partial: 'modules/cs_201' if can? :take_cs_201, using: SchoolPolicy %>
```

This will check call `has_taken(:cs_101)` on the result of `current_user`

Other usage examples:

```ruby
# with subject
can? User.find(1), :drive, car, using: HighwayCode

# without subject (assumes current_user if available)
can? :drive, car, using: HighwayCode

# multiple policies
can? :park, car, using: [HighwayCode, ParkingRules]

# without object
can? :cook_spaghetti, using: [KitchenPolicy]

# multiple actions
can? [:order, :drink], beer, using: BarPolicy
```

## Development

After checking out the repo, run `bundle` to install dependencies.
Then, run `bundle exec rake rspec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/muxcmux/umpire.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

