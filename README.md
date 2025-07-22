<!--BEGIN_BANNER_IMAGE-->

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="/.github/banner_dark.png">
  <source media="(prefers-color-scheme: light)" srcset="/.github/banner_light.png">
  <img style="width:100%;" alt="The LiveKit icon, the name of the repository and some sample code in the background." src="https://raw.githubusercontent.com/livekit/server-sdk-ruby/main/.github/banner_light.png">
</picture>

<!--END_BANNER_IMAGE-->

# LiveKit Server API for Ruby

<!--BEGIN_DESCRIPTION-->
Use this SDK to interact with <a href="https://livekit.io/">LiveKit</a> server APIs and create access tokens from your Ruby backend.
<!--END_DESCRIPTION-->

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
token.video_grant = LiveKit::VideoGrant.new(roomJoin: true, room: 'room-name')
token.attributes = { "mykey" => "myvalue" }
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

### Egress Service

`EgressServiceClient` is a ruby client to EgressService. Refer to [docs](https://docs.livekit.io/guides/egress) for more usage examples

```ruby
require 'livekit'

# starting a room composite to S3
egressClient = LiveKit::EgressServiceClient.new(
    "https://your-url",
    api_key: 'key',
    api_secret: 'secret'
);

info = egressClient.start_room_composite_egress(
    'room-name',
    LiveKit::Proto::EncodedFileOutput.new(
        file_type: LiveKit::Proto::EncodedFileType::MP4,
        filepath: "my-recording.mp4",
        s3: LiveKit::Proto::S3Upload.new(
            access_key: 'access-key',
            secret: 'secret',
            region: 'bucket-region',
            bucket: 'bucket'
        )
    )
)
puts info

# starting a track composite to RTMP
urls = Google::Protobuf::RepeatedField.new(:string, ['rtmp://url1', 'rtmps://url2'])
info = egressClient.start_track_composite_egress(
    'room-name',
    LiveKit::Proto::StreamOutput.new(
        protocol: LiveKit::Proto::StreamProtocol::RTMP,
        urls: urls
    ),
    audio_track_id: 'TR_XXXXXXXXXXXX',
    video_track_id: 'TR_XXXXXXXXXXXX'
)
puts info
```

### Environment Variables

You may store credentials in environment variables. If api-key or api-secret is not passed in when creating a `RoomServiceClient` or `AccessToken`, the values in the following env vars will be used:

- `LIVEKIT_API_KEY`
- `LIVEKIT_API_SECRET`

## License

The gem is available as open source under the terms of Apache 2.0 License.

<!--BEGIN_REPO_NAV-->
<br/><table>
<thead><tr><th colspan="2">LiveKit Ecosystem</th></tr></thead>
<tbody>
<tr><td>LiveKit SDKs</td><td><a href="https://github.com/livekit/client-sdk-js">Browser</a> · <a href="https://github.com/livekit/client-sdk-swift">iOS/macOS/visionOS</a> · <a href="https://github.com/livekit/client-sdk-android">Android</a> · <a href="https://github.com/livekit/client-sdk-flutter">Flutter</a> · <a href="https://github.com/livekit/client-sdk-react-native">React Native</a> · <a href="https://github.com/livekit/rust-sdks">Rust</a> · <a href="https://github.com/livekit/node-sdks">Node.js</a> · <a href="https://github.com/livekit/python-sdks">Python</a> · <a href="https://github.com/livekit/client-sdk-unity">Unity</a> · <a href="https://github.com/livekit/client-sdk-unity-web">Unity (WebGL)</a> · <a href="https://github.com/livekit/client-sdk-esp32">ESP32</a></td></tr><tr></tr>
<tr><td>Server APIs</td><td><a href="https://github.com/livekit/node-sdks">Node.js</a> · <a href="https://github.com/livekit/server-sdk-go">Golang</a> · <b>Ruby</b> · <a href="https://github.com/livekit/server-sdk-kotlin">Java/Kotlin</a> · <a href="https://github.com/livekit/python-sdks">Python</a> · <a href="https://github.com/livekit/rust-sdks">Rust</a> · <a href="https://github.com/agence104/livekit-server-sdk-php">PHP (community)</a> · <a href="https://github.com/pabloFuente/livekit-server-sdk-dotnet">.NET (community)</a></td></tr><tr></tr>
<tr><td>UI Components</td><td><a href="https://github.com/livekit/components-js">React</a> · <a href="https://github.com/livekit/components-android">Android Compose</a> · <a href="https://github.com/livekit/components-swift">SwiftUI</a> · <a href="https://github.com/livekit/components-flutter">Flutter</a></td></tr><tr></tr>
<tr><td>Agents Frameworks</td><td><a href="https://github.com/livekit/agents">Python</a> · <a href="https://github.com/livekit/agents-js">Node.js</a> · <a href="https://github.com/livekit/agent-playground">Playground</a></td></tr><tr></tr>
<tr><td>Services</td><td><a href="https://github.com/livekit/livekit">LiveKit server</a> · <a href="https://github.com/livekit/egress">Egress</a> · <a href="https://github.com/livekit/ingress">Ingress</a> · <a href="https://github.com/livekit/sip">SIP</a></td></tr><tr></tr>
<tr><td>Resources</td><td><a href="https://docs.livekit.io">Docs</a> · <a href="https://github.com/livekit-examples">Example apps</a> · <a href="https://livekit.io/cloud">Cloud</a> · <a href="https://docs.livekit.io/home/self-hosting/deployment">Self-hosting</a> · <a href="https://github.com/livekit/livekit-cli">CLI</a></td></tr>
</tbody>
</table>
<!--END_REPO_NAV-->
