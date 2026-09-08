## [Unreleased]

## [1.1.0]

### Added

- `EgressServiceClient#start_egress`, a unified egress entry point taking a single source (`template:`, `web:`, or `media:`), a list of `outputs:`, an optional default `storage:` for outputs that don't set their own, and per-request `webhooks:`. Reachable as `egress.start_egress` from `LiveKit::LiveKitAPI`.
- `EncodingOptionsPreset::PASSTHROUGH`, selectable through the existing `preset:` kwarg on `start_egress`, which skips transcoding for a single-track egress.

### Changed

- **Breaking:** `LiveKit::TokenVerifier#verify` now requires an `exp` claim and raises `JWT::MissingRequiredClaim` for a token without one. Tokens minted by `LiveKit::AccessToken` always set `exp`, so this only affects tokens issued elsewhere with no expiry.
- The `jwt` runtime dependency now requires `>= 2.3.0` (was `>= 2.2.3`), for `required_claims` support.

### Removed

- `UpdateEgressRequest` from the generated protobuf stubs, following the removal of the unused `UpdateEgress` RPC upstream. It was never reachable through any client method.

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
