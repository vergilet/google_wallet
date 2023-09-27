<p align="right">
    <a href="https://github.com/vergilet/google_wallet"><img align="" src="https://user-images.githubusercontent.com/2478436/51829223-cb05d600-22f5-11e9-9245-bc6e82dcf028.png" width="56" height="56" /></a>
<a href="https://rubygems.org/gems/google_wallet"><img align="right" src="https://user-images.githubusercontent.com/2478436/51829691-c55cc000-22f6-11e9-99a5-42f88a8f2a55.png" width="56" height="56" /></a>
</p>


<p align="center">
    <a href="https://rubygems.org/gems/repost">
  <img width="460" src="https://github.com/vergilet/google_wallet/assets/2478436/5f9c5925-129a-401e-bd46-82e6ae2b2430"></a>
</p>



# GoogleWallet
Unofficial Ruby Gem for [Google Wallet API](https://developers.google.com/wallet).

## Prerequisites
Before you use the Google Wallet API for an integration, complete first four steps from [this guide](https://developers.google.com/wallet/tickets/events/web/prerequisites).

*On 3rd step you are going to obtain **key.json**, which will be needed for the gem initialization.*

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'google_wallet'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install google_wallet

## Usage

Create initializer:
```ruby
# config/initializers/google_wallet.rb

GoogleWallet.configure do |config|
  config.load_credentials_from_file('./key.json')
  config.issuer_id = '33880000000XXXXXXXX'
  config.debug_mode = true
  config.logger = Logger.new(STDOUT)
end
```

### EventTicket

#### Create class (event representation):
```ruby
event_attributes = {
  # required fields
  class_identifier: 'Event-123456', 
  event_name: 'Solo Singing Contest #1 Yay!', 
  issuer_name: 'iChar System',
  
  # other fields
  event_id: '123456',
  logo_url: 'https://images.unsplash.com/photo-1475721027785-f74eccf877e2?auto=format&fit=crop&w=360&h=360',
  hero_image_url: 'https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?auto=format&fit=crop&w=1032&h=336',
  homepage_url: 'https://example.com',
  country_code: 'no',
  venue_name: 'Opera Theater',
  venue_address: "Shevchenka street 41/5, Ukraine, Kyiv",
  start_date_time: '2023-09-27T22:30',
  end_date_time: '2023-09-28T01:30',
  hex_background_color: '#ff0077',
  callback_url: 'https://example.com/gpass_callback'
}


# Create Resource of EventTicket Class
event = GoogleWallet::Resources::EventTicket::Class.new(attributes: event_attributes)

# Push Class to Google Wallet API
event.push
```

#### Create object (ticket representation):
```ruby
ticket_attributes = {
  # required fields
  object_identifier: 'fd9b637f-0381-42ad-9161-b4d887d79d9f',
  class_identifier: 'Event-12345',

  # other fields
  grouping_id: 'order-12345',
  ticket_type: 'VIP Adult Plus',
  section: 'The Sponsor Felt-F Overpower',
  seat: '65',
  row: '17',
  gate: 'G3, G4',
  ticket_holder_name: 'Yaro Developer',
  qr_code_value: '12345678',
  ref_number: 'cdeqw',
  valid_time_start: '2023-09-27T22:30',
  valid_time_end: '2023-09-28T02:00',
  micros: 82_000_000,
  currency_code: 'NOK',
  hex_background_color: '#0090ff'
}

# Create Resource of EventTicket Object
ticket = GoogleWallet::Resources::EventTicket::Object.new(attributes: ticket_attributes)

# Push Object to Google Wallet API

# separated push and sign
ticket.push
jwt = ticket.sign(push_resource: false)

# or combined - just use sign
jwt = ticket.sign # default, push_resource: true

"https://pay.google.com/gp/v/save/#{jwt}"

```

### Result

<p align="center">
    <a href="https://rubygems.org/gems/repost">
  <img src="https://github.com/vergilet/google_wallet/assets/2478436/df8f6ec9-ec45-4226-a0cf-65dc6f69f9b5"></a>
</p>


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/vergilet/google_wallet.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
