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
Generated files

* config/deflectable.yml
* public/403.html

#### deflectable.yml

```yaml
# config/deflectable.yml

:log: true         # default false
:whitelist:        # or :blacklist
  - 192.168.1.1
  - 10.20.30.0/24  # ip range
  - 3ffe:505:2::1  # IPv6 supported
```

### Modified config.ru

```ruby
# config.ru

use Deflectable::Watcher
```
