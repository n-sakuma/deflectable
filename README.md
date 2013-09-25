# deflectable

RailsアプリにIP制限 (ブラックリスト、ホワイトリスト)を適用

## Installation

Add this line to your application's Gemfile:

    gem 'deflectable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install deflectable

## Usage


### Configure

```bash
$ rails generate deflectable:install
```

* generated 'config/deflectable.yml'
* generated 'public/403.html'

### Modified config.ru

```ruby
# config.ru

use Deflectable::Watcher
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
