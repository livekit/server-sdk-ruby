## [Unreleased]

## [0.9.1] - 2026-02-14

### Fixed

- Fixed Ruby 3 compatibility issue in `AgentDispatchServiceClient` where `auth_header` was called with positional arguments instead of keyword arguments, causing `ArgumentError` in Ruby 3+

## [0.1.0] - 2021-07-25

- Initial release
