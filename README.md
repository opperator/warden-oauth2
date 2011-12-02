# Warden::OAuth2

This library provides a robust set of authorization strategies for
Warden meant to be used to implement an OAuth 2.0 ([draft 22][oauth2])
provider.

## Usage

```ruby
require 'warden-oauth2'

class MyAPI < Grape::API
  use Warden::Manager do |config|
    strategies.add :bearer, Warden::OAuth2::Strategies::Bearer
    strategies.add :client, Warden::OAuth2::Strategies::Client
    strategies.add :public, Warden::OAuth2::Strategies::Public

    config.default_strategies :bearer, :client, :public
  end
end
```

## Configuration

You can configure Warden::OAuth2 like so:

```ruby
Warden::OAuth2.configure do |config|
  config.some_option = some_value
end
```

### Configurable Options

* **client_model:** A class that responds to `.locate(id,secret=nil)` 
  represents a client application. Defaults to `ClientApplication`.
* **token_model:** A class that responds to `.locate(token)` and
  represents a single access token. Should also respond to
  `#scope?(symbol)` for OAuth2 authorization scopes.

## Strategies

### Bearer

This strategy authenticates by trying to find an access token that is
supplied according to the OAuth 2.0 Bearer Token specification
([draft 8][oauth2-bearer]). It does this by first extracting the access
token in string form and then calling the `.locate` method on your
access token model (see **Configuration** above).

### Client

This strategy authenticates an OAuth 2.0 client application directly for
endpoints that don't require a specific user. You might use this
strategy when you want to create an API for client statistics or if you
wish to rate limit based on a client application even for publicly
accessible endpoints.

### Public

This strategy succeeds by default and only fails if the authentication
scope is set and is something other than `:public`. The Warden user is
set to nil when this strategy succeeds.

[oauth2]: http://tools.ietf.org/html/draft-ietf-oauth-v2-22
[oauth2-bearer]: http://tools.ietf.org/html/draft-ietf-oauth-v2-bearer-08
