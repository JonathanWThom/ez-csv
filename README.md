# Ez::Csv

Ez::Csv is a wrapper around Ruby's standard CSV class. The goal is to make it simple
to create, read from, and modify CSV files. The project is a work in progress. See
[Usage](#usage) for a preview of the public methods in development for V1.

## Installation

**Note: This gem is not yet published**

Add this line to your application's Gemfile:

```ruby
gem "ez-csv"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ez-csv

## Usage

**Many of these features are either not yet complete, or have yet to have their
method signature totally defined.**

```
# Create a CSV from scratch
csv = Ez::Csv.new(headers: ["Name", "Phone Number", "Email"])
csv.generate("my_file_path")

# Convert an already existing CSV to an Ez::Csv object
csv = Ez::Csv.new.read("my_file_path", headers: true)

# Modify Ez::Csv object
csv.add_row("Name": Bilbo Baggins, "Email": "theonering@gmail.com")
csv.remove_row(0) # by index
csv.remove_rows(0, 2)
csv.sort_columns_by("column_name", order: :desc)
csv.change_row_order(new_order)
csv.update_row(0, block)
csv.update_rows(0, 2, block) # this syntax might not work
# After modifying, you may run csv.generate again to rewrite your updated CSV

# Query Ez::Csv object
csv.rows
csv.find_rows_where(block) # returns indexes

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/JonathanWThom/ez-csv.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
