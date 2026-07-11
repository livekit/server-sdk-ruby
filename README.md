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

This library is designed to work with Ruby 3.1 and above.

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

## Migrating from 0.x to 1.x

v1.0 is a breaking release. The most important change is behavioral: **service methods now return the response message directly and raise on failure**, instead of returning a `Twirp::ClientResp` that you had to unwrap and error-check yourself.

### Return values and error handling (breaking)

In 0.x, every call returned a `Twirp::ClientResp`: you read the result from `.data`, and a failed call came back with a non-nil `.error`. Nothing was raised, so an unchecked failure silently surfaced later as a `nil` result.

In 1.x, the result is returned directly, and failures raise `LiveKit::ServerError` (or `LiveKit::SipCallError` for SIP dialing calls).

```ruby
# 0.x — unwrap .data, check .error manually
resp = client.create_room('myroom')
if resp.error
  # handle failure
else
  room = resp.data
end

# 1.x — result returned directly, failures raise
begin
  room = api.room.create_room('myroom')
rescue LiveKit::ServerError => e
  # e.code, e.message, e.metadata
end
```

See [Error handling](#error-handling) below for details, including the SIP-specific `LiveKit::SipCallError`.

### Single entry point (recommended)

0.x constructed each service client on its own. 1.x adds `LiveKit::LiveKitAPI`, a single entry point that exposes every service (`room`, `egress`, `ingress`, `sip`, `agent_dispatch`, `connector`) over a shared connection.

```ruby
# 0.x
client = LiveKit::RoomServiceClient.new('https://my.livekit.instance',
    api_key: 'yourkey', api_secret: 'yoursecret')
client.list_rooms

# 1.x
api = LiveKit::LiveKitAPI.new('https://my.livekit.instance',
    api_key: 'yourkey', api_secret: 'yoursecret')
api.room.list_rooms
```

The individual clients (`LiveKit::RoomServiceClient`, etc.) still exist and take the same arguments, so you can adopt the new error handling first and switch to `LiveKitAPI` later — but note they raise on failure now too.

### Also new in 1.x

- **Token authentication** — construct `LiveKitAPI` (or a client) with a pre-signed `token:` instead of an API key/secret, for client-side use where the secret must not be exposed. See [Authentication](#authentication).
- Bug fixes: `start_participant_egress` no longer raises when given a single output; `AgentDispatchServiceClient#get_dispatch` / `#list_dispatch` now return correctly.

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

### Authentication

Every request to the server APIs is authenticated. There are two modes:

- **API key & secret** — recommended for backend use. The SDK signs a short-lived token per request from your key and secret. Keep your API secret on the server; never ship it to a client.
- **Access token** — for frontend / client-side use, where the API secret must not be exposed. Pass a pre-signed [access token](https://docs.livekit.io/home/get-started/authentication/) that already carries the grants for the operations you'll perform; the SDK sends it verbatim.

```ruby
# backend (API key & secret): set LIVEKIT_URL, LIVEKIT_API_KEY, and
# LIVEKIT_API_SECRET, then construct with no arguments...
api = LiveKit::LiveKitAPI.new

# ...or pass any of them explicitly to override the corresponding env var:
api = LiveKit::LiveKitAPI.new('https://my.livekit.instance', api_key: 'yourkey', api_secret: 'yoursecret')

# frontend (pre-signed access token): with LIVEKIT_URL set, pass just the token:
api = LiveKit::LiveKitAPI.new(token: 'a-pre-signed-token')
```

The url and credentials fall back to the `LIVEKIT_URL`, `LIVEKIT_API_KEY`, `LIVEKIT_API_SECRET`, and `LIVEKIT_TOKEN` environment variables. Values you pass explicitly take precedence; the environment variables are used only as a fallback for arguments you omit — an ambient `LIVEKIT_TOKEN`, for example, won't override an explicitly-provided API key and secret.

### Server APIs

`LiveKit::LiveKitAPI` is a single entry point to every server API, exposing each service through a reader: `room`, `egress`, `ingress`, `sip`, `agent_dispatch`, and `connector`. Each method returns the response message directly and raises `LiveKit::ServerError` on failure. See [service apis](https://docs.livekit.io/guides/server-api) for the full list.

```ruby
require 'livekit'

api = LiveKit::LiveKitAPI.new('https://my.livekit.instance',
    api_key: 'yourkey', api_secret: 'yoursecret')

name = 'myroom'

room = api.room.create_room(name)

api.room.list_rooms

api.room.list_participants(room: name)

api.room.mute_published_track(room: name, identity: 'participant',
                              track_sid: 'track-id', muted: true)

api.room.remove_participant(room: name, identity: 'participant')

api.room.delete_room(room: name)
```

### Error handling

Failed API calls raise `LiveKit::ServerError`, which exposes the error `code`, message, and any server-provided `metadata`. SIP dialing calls raise `LiveKit::SipCallError` (a `ServerError` subclass) that also exposes the SIP status:

```ruby
begin
  api.sip.create_sip_participant('trunk-id', '+15105550100', 'my-room', wait_until_answered: true)
rescue LiveKit::SipCallError => e
  puts e                 # e.g. "SIP call failed: 486 Busy Here (resource_exhausted)"
  puts e.sip_status_code # 486
rescue LiveKit::ServerError => e
  puts e.code
end
```

The per-service clients (`LiveKit::RoomServiceClient`, etc.) can also be constructed individually with the same arguments.

### Egress Service

Egress is reached via `api.egress`. Refer to [docs](https://docs.livekit.io/guides/egress) for more usage examples.

```ruby
require 'livekit'

api = LiveKit::LiveKitAPI.new('https://your-url', api_key: 'key', api_secret: 'secret')

# starting a room composite to S3
info = api.egress.start_room_composite_egress(
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
info = api.egress.start_track_composite_egress(
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

You may store credentials in environment variables. When the corresponding argument is not passed to `LiveKitAPI` (or `AccessToken`), these are used:

- `LIVEKIT_URL`
- `LIVEKIT_API_KEY`
- `LIVEKIT_API_SECRET`
- `LIVEKIT_TOKEN`

## License

The gem is available as open source under the terms of Apache 2.0 License.

<!--BEGIN_REPO_NAV-->
<br/><table>
<thead><tr><th colspan="2">LiveKit Ecosystem</th></tr></thead>
<tbody>
<tr><td>Agents SDKs</td><td><a href="https://github.com/livekit/agents">Python</a> · <a href="https://github.com/livekit/agents-js">Node.js</a></td></tr><tr></tr>
<tr><td>LiveKit SDKs</td><td><a href="https://github.com/livekit/client-sdk-js">Browser</a> · <a href="https://github.com/livekit/client-sdk-swift">Swift</a> · <a href="https://github.com/livekit/client-sdk-android">Android</a> · <a href="https://github.com/livekit/client-sdk-flutter">Flutter</a> · <a href="https://github.com/livekit/client-sdk-react-native">React Native</a> · <a href="https://github.com/livekit/rust-sdks">Rust</a> · <a href="https://github.com/livekit/node-sdks">Node.js</a> · <a href="https://github.com/livekit/python-sdks">Python</a> · <a href="https://github.com/livekit/client-sdk-unity">Unity</a> · <a href="https://github.com/livekit/client-sdk-unity-web">Unity (WebGL)</a> · <a href="https://github.com/livekit/client-sdk-esp32">ESP32</a> · <a href="https://github.com/livekit/client-sdk-cpp">C++</a></td></tr><tr></tr>
<tr><td>Starter Apps</td><td><a href="https://github.com/livekit-examples/agent-starter-python">Python Agent</a> · <a href="https://github.com/livekit-examples/agent-starter-node">TypeScript Agent</a> · <a href="https://github.com/livekit-examples/agent-starter-react">React App</a> · <a href="https://github.com/livekit-examples/agent-starter-swift">SwiftUI App</a> · <a href="https://github.com/livekit-examples/agent-starter-android">Android App</a> · <a href="https://github.com/livekit-examples/agent-starter-flutter">Flutter App</a> · <a href="https://github.com/livekit-examples/agent-starter-react-native">React Native App</a> · <a href="https://github.com/livekit-examples/agent-starter-embed">Web Embed</a></td></tr><tr></tr>
<tr><td>UI Components</td><td><a href="https://github.com/livekit/components-js">React</a> · <a href="https://github.com/livekit/components-android">Android Compose</a> · <a href="https://github.com/livekit/components-swift">SwiftUI</a> · <a href="https://github.com/livekit/components-flutter">Flutter</a></td></tr><tr></tr>
<tr><td>Server APIs</td><td><a href="https://github.com/livekit/node-sdks">Node.js</a> · <a href="https://github.com/livekit/server-sdk-go">Golang</a> · <b>Ruby</b> · <a href="https://github.com/livekit/server-sdk-kotlin">Java/Kotlin</a> · <a href="https://github.com/livekit/python-sdks">Python</a> · <a href="https://github.com/livekit/rust-sdks">Rust</a> · <a href="https://github.com/agence104/livekit-server-sdk-php">PHP (community)</a> · <a href="https://github.com/pabloFuente/livekit-server-sdk-dotnet">.NET (community)</a></td></tr><tr></tr>
<tr><td>Resources</td><td><a href="https://docs.livekit.io">Docs</a> · <a href="https://docs.livekit.io/mcp">Docs MCP Server</a> · <a href="https://github.com/livekit/livekit-cli">CLI</a> · <a href="https://cloud.livekit.io">LiveKit Cloud</a></td></tr><tr></tr>
<tr><td>LiveKit Server OSS</td><td><a href="https://github.com/livekit/livekit">LiveKit server</a> · <a href="https://github.com/livekit/egress">Egress</a> · <a href="https://github.com/livekit/ingress">Ingress</a> · <a href="https://github.com/livekit/sip">SIP</a></td></tr><tr></tr>
<tr><td>Community</td><td><a href="https://community.livekit.io">Developer Community</a> · <a href="https://livekit.io/join-slack">Slack</a> · <a href="https://x.com/livekit">X</a> · <a href="https://www.youtube.com/@livekit_io">YouTube</a></td></tr>
</tbody>
</table>
<!--END_REPO_NAV-->
