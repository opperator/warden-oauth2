# Warden::OAuth2

This library provides a robust set of authorization strategies for
Warden meant to be used to implement an OAuth 2.0 ([draft 22][oauth2])
provider.

## Usage

```ruby
require 'warden-oauth2'

class MyAPI < Grape::API
  use Warden::OAuth2::Manager do |config|
    config.token_scope :vendor, %r{^/vendor}
  end
end
```

[oauth2]: http://tools.ietf.org/html/draft-ietf-oauth-v2-22
