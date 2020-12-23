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
  ```require 'access_policy'```
  
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
  
  
 # Keys of YAML with descriptions

| Key | Values | Required | Description |
| :--- | :--- | :--- | :--- |
| default |-|Mandatory|If no user roles are found, then this default section rule will be checked. |
| userrole |-|Mandatory|This section is use for giving the rules depending upon the role of user in your application. "userrole" will be replaced with super_admin, admin, etc, as per requirement of your application. |
|default-action|{ allow \| deny }|Mandatory|This section basically allow or deny the url if nothing is matched for that url in the rules.|
|inherits |<other userrole rule block>|Optional|Use to inherits other rule block by metioning the name of the desire block. If the url does not match any rules in the userrole block it belongs, it will then match it from the inherited rules. It can be multi-level.|
|rules |-|Mandatory|This is an array block containing all the rules that are allowed or denied by the user role. If no rules are required leave it with a blank arrar ( [] ).|
|url |-|Mandatory|This is a block containing the pattern of the url, whether the url is absolute or regex and a value that has the main url|
|pattern |{ absolute \| regex}|Optional|This will denote what type of url pattern is the particular url. If pattern is not given, by default it will treat the pattern as absolute.|
|value |<url>|Mandatory|This is the url path, can be a regex or an absolute path.|
|desc |<string>|Mandatory|Short description of the url.|
|priority |<number>|Mandatory|This denotes which url will be given priority, if both absolute or regex url are matches, higher priority url will be teated first.|
|methods |< all http(s) methods >|Optional|This are http(s) methods ( GET, POST, DELETE, PATCH, PUT, others )that are allowed for the url. This are given in array format.|
|action |{ allow \| deny }|Mandatory|This will determine if the url is allowed or denied for the methods and other parameters present. |
|params |-|Optional|This will list all the parameters and their methods, location, path, values.   This is an array object where multiple parameters can be check depending upon their method.|
|method |< http(s) method >|Optinal|The method for which the parameters will be check for the url.|
|param-location |{ url \| body \| json }|Mandatory (if params key present)|The location of the params, whether it is in url or in body or inside a json.|
|param-path |<key of the parameters>|Mandatory(if params key present)|The key of the parameters, if param-location is url or body give the key as it is (example param-path: product_action). if param-location is json give the key as $.<key> (example param-path: $.product_action).|
|values |<value of the parameters>|Mandatory(if param-path key present)|The values that are allowed for the params-path. It is given as array of values.| 
  
  

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/MijanurR/user_access_manager. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/MijanurR/user_access_manager/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the UserAccessManager project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/MijanurR/user_access_manager/blob/master/CODE_OF_CONDUCT.md).
