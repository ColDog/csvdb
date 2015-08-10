# Csvdb

Really simple object relational mapping for CSV spreadsheets. Loads all data into a ruby array first so not appropriate for very large datasets. However, it's just as fast as working with a 2d ruby array, so it's very fast for reasonably sized datasets.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'csvdb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install csvdb

## Usage

#### CRUD Functions
```ruby
table = Csvdb.new(file: 'table.csv')
table.cols.keys           #=> [:id, :name] The table headings (from row[0] in file)
table.create(
  id: 1, name: 'foobar'
)                         #=> [1, 'foobar'] Newly created row
row = table.find(0)       #=> [1, 'foobar'] find by index in array
row.id                    #=> 1
row.update(id: 2)         #=> [2, 'foobar']
row.delete
row.find(0)               #=> nil
```

#### Querying
```ruby
table = Csvdv.new(file: 'table.csv')
table.count #=> 5

# queries always return new table objects, with the same headings,
# just filtered by the block
query = table.where { |row| row[table.id] == 1 }
query.count #=> 1

# joins also always return table objects.
# the join joins on the same column name in each table.
joined = table.join(another_table, :column)
```

#### Printing
```ruby
table = Csvdb.new(file: 'table.csv')
table.pretty
+---------+-------+--------+--------+----------+
| version | type  | counts | resets | time     |
+---------+-------+--------+--------+----------+
| 1.1.0   | build | 741    | 6      | 0.046694 |
...

```


## Contributing

1. Fork it ( https://github.com/ColDog/csvdb/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
