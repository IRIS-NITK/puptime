# Puptime

Welcome to P|Uptime!

## Installation

# TODO: Write instructions
```ruby
gem 'puptime'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install puptime

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Please Do!!

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## File Structure
```text
├── bin
│   ├── console
│   ├── puptime
│   └── setup
├── exe
│   └── puptime
├── Gemfile
├── lib
│   ├── puptime (Root of project)
│   │   ├── cli (Handles CLI of the app)
│   │   │   ├── base.rb
│   │   │   ├── start.rb (./puptime start)
│   │   │   └── stop.rb (Gracefully shutdown)
│   │   ├── cli.rb (Parses Args via Thor)
│   │   ├── configuration.rb (Handles config file)
│   │   ├── logging.rb (Custom logger)
│   │   ├── notification_queue.rb (Thread safe queue for notifications)
│   │   ├── notifier
│   │   │   ├── base.rb
│   │   │   ├── email.rb (Email notifications)
│   │   │   └── teams.rb (Teams notification)
│   │   ├── notifier.rb 
│   │   ├── persistence (Database layer -- incomplete)
│   │   │   ├── config
│   │   │   │   └── database.yml
│   │   │   ├── db
│   │   │   │   ├── migrate
│   │   │   │   │   ├── 20200526135008_add_services_table.rb
│   │   │   │   │   ├── 20200526143441_add_tcp_table.rb
│   │   │   │   │   └── 20200526144321_add_dns_table.rb
│   │   │   │   └── schema.rb
│   │   │   ├── models
│   │   │   │   ├── service.rb
│   │   │   │   └── services
│   │   │   │       ├── dns.rb
│   │   │   │       └── tcp.rb
│   │   │   └── persistence.rb
│   │   ├── service
│   │   │   ├── base.rb
│   │   │   ├── dns.rb (DNS logic to ping based on config)
│   │   │   ├── redis.rb (Redis ")
│   │   │   └── tcp.rb (TCP ")
│   │   ├── service.rb
│   │   ├── service_set.rb (Store all services in config)
│   │   └── version.rb
│   └── puptime.rb
├── LICENSE.txt
├── log.txt
├── puptime.gemspec
├── Rakefile
├── README.md
└── test
    ├── puptime_test.rb
    └── test_helper.rb
```

Create a configuration file as follows

`~/.puptime/.config.yml`

```yaml
---
monitors:
  -
    group: pavan
    interval: 5s
    name: dns-1
    options:
      record_type: NS
      resource: google.com
      results: "ns3.google.com, ns4.google.com, ns2.google.com"
    type: DNS

  -
    group: pavan
    interval: 3s
    name: dns-2
    options:
      record_type: NS
      resource: google.com
      results: "ns3.google.com, ns4.google.com, ns2.google.com, ns1.google.com"
      match: 1
    type: DNS

  -
    group: pavan
    interval: 2s
    name: redis-1
    options:
      ip_addr: localhost
      port: 6379
      db: 15
    type: Redis

notifications:
  -
    channel: email
    to: abc@gmail.com
    from: pqr@gmail.com
    delivery_method: smtp
    address: smtp.gmail.com
    port: 587
    user_name: vachhanihpavan
    password: 1234
    authentication: plain
    enable_starttls_auto: true

  -
    channel: teams
    api_key: skfjhsjicnfiHIUHSLKUEZn2134
```
