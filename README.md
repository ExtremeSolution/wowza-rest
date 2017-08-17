# WowzaRest

[![Build Status](https://travis-ci.org/ExtremeSolution/wowza-rest.svg?branch=master)](https://travis-ci.org/ExtremeSolution/wowza-rest)
[![Code Climate](https://codeclimate.com/github/hazemtaha/wowza_rest/badges/gpa.svg)](https://codeclimate.com/github/hazemtaha/wowza_rest)
[![Gem Version](https://badge.fury.io/rb/wowza_rest.svg)](https://badge.fury.io/rb/wowza_rest)

Ruby wrapper for Wowza Streaming Engine Rest API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wowza_rest'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wowza_rest

## Usage

Create Client:
```ruby
client = WowzaRest::Client.new(
  host: 'WOWZA_ENGINE_IP_OR_URL',
  port: 'PORT_NUMBER',
  username: 'WOWZA_ENGINE_USERNAME',
  password: 'WOWZA_ENGINE_PASSWORD'
) 
```

#### Applications
- List All Applications
```ruby
applications = client.applications
```
- Fetch single application
```ruby
application = client.get_application('APPLICATION_NAME')
```
- Create a new application
```ruby
client.create_application({
	name: 'APPLICATION_NAME',
	appType: 'LIVE|VOD'
})
```
- Update Application
```ruby
client.update_application('APPLICATION_NAME', {
# ... configs to be updated
})
```
- Delete Application
```ruby
client.delete_application('APPLICATION_NAME')
```

### Instances
- List all instances for an application
```ruby
client.instances('APPLICATION_NAME')
```
- Fetch single instance
```ruby
client.get_instance('APPLICATION_NAME', 'INSTANCE_NAME') 
# instance name can be ommited and defaults to the default instance
```
- Get a single incoming stream monitoring stats
```ruby
client.get_incoming_stream_stat('APPLICATION_NAME', 'STREAM_NAME', 'INSTANCE_NAME')
# instance name can be ommited and defaults to the default instance
```

### Publishers
- Create publisher (Wowza SE Source)
```ruby
client.create_publisher('PUBLISHER_NAME', 'PUBLISHER_PASSWORD')
```
- Delete publisher (Wowza SE Source)
```ruby
client.delete_publisher('PUBLISHER_NAME')
```
### Server Status
```ruby
client.server_status
```
### SMILs
- List All SMILs
```ruby
smils = client.smils
```
- Fetch single application
```ruby
smil = client.get_smil('SMIL_NAME')
```
- Create SMIL 
```ruby
client.create_smil('SMIL_NAME', 'SMIL_BODY')
```
- Update SMIL 
```ruby
client.update_smil('SMIL_NAME', 'SMIL_BODY')
```
- Delete publisher
```ruby
client.delete_smil('SMIL_NAME')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ExtremeSolution/wowza-rest. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

