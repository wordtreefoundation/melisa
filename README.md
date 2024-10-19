Melisa is a Ruby gem that wraps the very efficient [Marisa Trie C++ library](https://github.com/s-yata/marisa-trie). See also Marisa Trie's [README](https://www.s-yata.jp/marisa-trie/docs/readme.en.html).

A "trie" is a useful data structure for storing strings, especially ngrams.

Installation
------------

```
sudo apt-get install make dh-autoreconf build-essential
```

Example
-------

```gem install melisa```

```ruby
require 'melisa'

trie = Melisa::Trie.new
trie.add('snow')
trie.add('snow cone')
trie.add('ice')
trie.add('ice cream')

trie.search('ice').keys
# => ["ice", "ice cream"]
```

You can also save and load complete tries. Marisa Tries are space efficient, often achieving significant compression over regular string or hash storage.

```ruby
trie = Melisa::Trie.new(['snow', 'snow cone'])
trie.save('winter.trie')
```

```ruby
trie = Melisa::Trie.new
trie.load('winter.trie')

trie.include? 'snow'
# => true
```

Melisa includes an IntTrie type that can be used to time- and space-efficiently store integer values in association with a string:

```ruby
trie = Melisa::IntTrie.new "one" => 1, "two" => 2, "onetwo" => 3
trie['one']
# => 1

trie.get_all('one')
# => [3, 1]
```

Features
--------
 - fast search for exact strings and prefixes
 - has a BytesTrie that can be used to store binary data
 - has an IntTrie that can be used to store integer values easily
 - Ruby bindings for Marisa Trie built into the gem (require 'marisa')


About
-----
(c) 2014 Duane Johnson
License: MIT

## Development

After checking out the repo, run bin/setup to install dependencies. Then, run rake spec to run the tests. You can also run bin/console for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run bundle exec rake install. To release a new version, update the version number in version.rb, and then run bundle exec rake release, which will create a git tag for the version, push git commits and the created tag, and push the .gem file to rubygems.org.
