# UserAccessManager

 Some time clients wants to restrict user from accessing  the sensitive module/url of an application based on their roles. This gem serve this purpose very efficiently with minimal implementation.it mainly deals with the url pattern.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'user_access_manager'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install user_access_manager

## Usage

  #### In the Application controller add AccessPolicy  module
  ```include AccessPolicy```
  ##### define a yml under config and named it as ``access_policies.yml``. 
  Sample file:  https://github.com/MijanurR/user_access_manager/blob/master/sample_access_policies.yml
   ####  Add the following line in the application.rb
   ``` config.AccessPolicyMaster = YAML::load(File.read("config/access_policies.yml")) ```
   ``` 
class Application < Rails::Application 
        config.AccessPolicyMaster = YAML::load(File.read("config/access_policies.yml")) 
 end
 ```
  
  #### define a custom method in Application controller.
  ```
  def authorize_user_access
    user_role =  <get user role from current user>  
    authorize_access(user_role)
  end
  
  ```
  
  apply before_action on the action that you are going to restrict
   ``` before_action :authorize_user_access ```
  
  
  
  
  

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/MijanurR/user_access_manager. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/MijanurR/user_access_manager/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the UserAccessManager project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/MijanurR/user_access_manager/blob/master/CODE_OF_CONDUCT.md).
