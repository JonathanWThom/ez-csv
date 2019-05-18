# Ez::Csv

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/ez/csv`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ez-csv'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ez-csv

## Usage

```
csv = Ez::Csv.new(headers: ["Name", "Phone Number", "Email"])
csv.add_row("Name": Bilbo Baggins, "Email": "theonering@gmail.com")
csv.rows
csv.remove_row(0)
csv.remove_rows(0, 2)
csv.generate("file_name") # or default
csv.sort_columns_by(field, order: :desc)
csv.new.read(path, headers: true) # return ez::csv object
csv.find_rows_where(block) # returns indexes
csv.update_row(0, block)
csv.update_rows(0, 2, block) # this syntax might now work

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/ez-csv.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
