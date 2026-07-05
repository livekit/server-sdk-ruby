## [Unreleased]

## [1.0.0]

### Added

- `LiveKit::LiveKitAPI`, a single entry point exposing every service through a reader (`room`, `egress`, `ingress`, `sip`, `agent_dispatch`, `connector`).
- Token authentication: construct clients (or `LiveKitAPI`) with a pre-signed `token:` that is sent verbatim, enabling client-side use without an API secret. Credentials fall back to `LIVEKIT_URL`, `LIVEKIT_TOKEN`, `LIVEKIT_API_KEY`, and `LIVEKIT_API_SECRET`.
- `LiveKit::SipCallError` (a `LiveKit::TwirpError`) raised by SIP dialing calls, exposing `sip_status_code` and `sip_status`.

### Changed

- **Breaking:** service methods now return the response message directly and raise `LiveKit::TwirpError` on failure, instead of returning a `Twirp::ClientResp`. Replace `resp = client.create_room(...); resp.data` with `room = client.create_room(...)`, and rescue `LiveKit::TwirpError` for errors.
- `faraday` is now a declared runtime dependency.

### Fixed

- `EgressServiceClient` no longer raises when a single output is passed to `start_participant_egress` (the request has no deprecated singular output field).
- `AgentDispatchServiceClient#get_dispatch` / `#list_dispatch` now return correctly (they previously assumed the RPC returned data directly).

## [0.1.0] - 2021-07-25

- Initial release
