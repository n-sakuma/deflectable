# deflectable

RailsアプリにIP制限 (ブラックリスト、ホワイトリスト)を適用

It is possible to add the ip limiting the rack app.


## Installation

Add this line to your application's Gemfile:

    gem 'deflectable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install deflectable


## Usage

### Configure

#### Generator

```bash
$ rails generate deflectable:install
```
Generated files

* config/deflectable.yml
* public/403.html


#### deflectable.yml

```yaml
### config/deflectable.yml

# default false
:log: true

# :whitelist or :blacklist
:whitelist:
  - 192.168.1.1
  - 10.20.30.0/24  # ip range
  - 3ffe:505:2::1  # IPv6 supported

# default: config/deflectable.yml (Rails.root)
:config_path: Rails.root.join('vendor/app/config/setting.yml')
```


### Modified config.ru

#### config.ru & deflectable.yml

```ruby
# config.ru

use Deflectable::Watcher

```

#### Define the settings in the block (only config.ru)

deflectable.ymlを設置せずに、ブロックで定義することもできる。

Possible to omit the 'deflectable.yml'.

```ruby
# config.ru

use Deflectable::Watcher do
  { :log => true,
    :whitelist => %w(192.168.1.1 10.20.30.0/24 3ffe:505:2::1)
  }
end
```
