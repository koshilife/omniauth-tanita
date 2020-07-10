# OmniAuth::Tanita

[![Test](https://github.com/koshilife/omniauth-tanita/workflows/Test/badge.svg)](https://github.com/koshilife/omniauth-tanita/actions?query=workflow%3ATest)
[![codecov](https://codecov.io/gh/koshilife/omniauth-tanita/branch/master/graph/badge.svg)](https://codecov.io/gh/koshilife/omniauth-tanita)
[![Gem Version](https://badge.fury.io/rb/omniauth-tanita.svg)](http://badge.fury.io/rb/omniauth-tanita)
[![license](https://img.shields.io/github/license/koshilife/omniauth-tanita)](https://github.com/koshilife/omniauth-tanita/blob/master/LICENSE.txt)

This gem contains the Tanita Health Planet strategy for OmniAuth.

## Before You Begin

You should have already installed OmniAuth into your app; if not, read the [OmniAuth README](https://github.com/intridea/omniauth) to get started.

Now sign into the [Health Planet API Settings page](https://www.healthplanet.jp/apis_account.do) and create an application. Take note of your API keys.

## Using This Strategy

First start by adding this gem to your Gemfile:

```ruby
gem 'omniauth-tanita'
```

If you need to use the latest HEAD version, you can do so with:

```ruby
gem 'omniauth-tanita', :github => 'koshilife/omniauth-tanita'
```

Next, tell OmniAuth about this provider. For a Rails app, your `config/initializers/omniauth.rb` file should look like this:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :tanita, "API_KEY", "API_SECRET"
end
```

Replace `"API_KEY"` and `"API_SECRET"` with the appropriate values you obtained [earlier](https://www.healthplanet.jp/apis_account.do).

## Scopes

The default scope is "innerscan".
If you use other scope, you can specify like so:

```ruby

Rails.application.config.middleware.use OmniAuth::Builder do

  # Sphygmomanometer
  provider :tanita, "API_KEY", "API_SECRET", :scope => 'sphygmomanometer'

  # Pedometer and Smug
  provider :tanita, "API_KEY", "API_SECRET", :scope => ['pedometer', 'smug'].join(',')

end
```

## Auth Hash Example

The auth hash `request.env['omniauth.auth']` would look like this:

```js
{
    "provider": "tanita",
    "uid": null, // uid will be empty, because there is no apis to get.
    "credentials": {
        "token": "ACCESS_TOKEN",
        "refresh_token": "REFRESH_TOKEN",
        "expires_at": 1581419031,
        "expires": true
    },
    "extra": {}
}
```

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/koshilife/omniauth-tanita). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the omniauth-tanita project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/koshilife/omniauth-tanita/blob/master/CODE_OF_CONDUCT.md).
