# LiveKit Server API for Ruby

Ruby API for server-side integrations with LiveKit. This gem provides the ability to create access tokens as well as access RoomService.

This library is designed to work with Ruby 2.6.0 and above.

## Installation

Add this line to your application's Gemfile:

### Gemfile

```ruby
gem 'livekit-server-sdk'
```

and then `bundle install`.

### Install system-wide

```shell
gem install livekit-server-sdk
```

## Usage

### Creating Access Tokens

Creating a token for participant to join a room.

```ruby
require 'livekit'

token = LiveKit::AccessToken.new(api_key: 'yourkey', api_secret: 'yoursecret')
token.identity = 'participant-identity'
token.name = 'participant-name'
token.add_grant(roomJoin: true, room: 'room-name')

puts token.to_jwt
```

By default, a token expires after 6 hours. You may override this by passing in `ttl` when creating the token. `ttl` is expressed in seconds.

### Setting Permissions with Access Tokens

It's possible to customize the permissions of each participant. See more details at [access tokens guide](https://docs.livekit.io/guides/access-tokens#room-permissions).

### Room Service

`RoomServiceClient` is a Twirp-based client that provides management APIs to LiveKit. You can connect it to your LiveKit endpoint. See [service apis](https://docs.livekit.io/guides/server-api) for a list of available APIs.

```ruby
require 'livekit'

client = LiveKit::RoomServiceClient.new('https://my.livekit.instance',
    api_key: 'yourkey', api_secret: 'yoursecret')

name = 'myroom'

client.list_rooms

client.list_participants(room: name)

client.mute_published_track(room: name, identity: 'participant',
                            track_sid: 'track-id', muted: true)

client.remove_participant(room: name, identity: 'participant')

client.delete_room(room: name)
```

### Environment Variables

You may store credentials in environment variables. If api-key or api-secret is not passed in when creating a `RoomServiceClient` or `AccessToken`, the values in the following env vars will be used:

- `LIVEKIT_API_KEY`
- `LIVEKIT_API_SECRET`

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
