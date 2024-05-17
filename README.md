# Snm::Fcm

<a href="https://badge.fury.io/rb/snm-fcm"><img src="https://badge.fury.io/rb/snm-fcm.svg" alt="Gem Version" height="18"></a>

Ruby Library to send notification on android via Firebase Cloud Messaging API (V1)

This library is based on Firebase Cloud Messaging API (V1) to send notification on android devices.

## Requirements
Version 0.1.6 requires at least Ruby 3.0.0, This library dependents on googleauth, redis, json and http gem.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ gem 'snm-fcm', '~> 0.1.5'

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install snm-fcm

## Usage
### Setup
Create an initializer file for ex rails-project/config/initializers/snm_fcm.rb
```
Snm::Fcm::Notification.configure do |config|
  config.credentails_file_path = 'path/to/my-fcm-e65a9915e042.json'
  config.redis_endpoint = 'redis://localhost:6379/1'
end
Snm::Fcm::Notification.setup
```
### Send notification
```
msg_data = {
  'message'=> {
    'token'=> 'android-device-fcm-token',
    'notification'=>
    {
      'title'=> 'Lorem ipsum',
      'body'=> 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
      'image'=> 'https://www.snmmaurya.com/images/me.jpg'
    },
    'data'=> {
      'key1'=> 'value1',
      'key2'=> 'value2'
      }
    }
}
respoonse = Snm::Fcm::Notification.deliver(msg_data)

# Success response:

{"name"=>"projects/my-fcm/messages/0:1715935676674045%f570bc3bf570bc3b"}

```
## How to get my-fcm-e65a9915e042.json

1. Got go https://console.firebase.google.com/

### For Android (FE)

2. Create your project for ex 'my-fcm' and download google-services.json to set up your android project.

### For Ruby
3. Go to the project click on settings icon next to Project Overview top left cornor.

    3.1 in the general tab you will find 'project id' copy this id and put somewhere in your system.
    
    3.2 Click on Cloud Messging tab -
    
    3.3 In side Firebase Cloud Messaging API (V1) panel.
    
    3.4 Click on Manage Service Accounts On the next page a service already be there click on the name of that serive name for ex 'firebase-adminsdk-4apop@my-fcm.iam.gserviceaccount.com'
    
    3.5 Click on advanced settings - choose 'keys' tab.
    
    3.6 Now create a new key type json download it (automatically downloaded) put this file somewhere in your system. this file is your my-fcm-e65a9915e042.json

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/snmmaurya/snm-fcm. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/snmmaurya/snm-fcm/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Snm::Fcm project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/snmmaurya/snm-fcm/blob/main/CODE_OF_CONDUCT.md).
