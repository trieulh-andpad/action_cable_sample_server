# AGENTS.md — Rails + AnyCable ActionCable Protocol Test Server

## Purpose
This repository is a Ruby on Rails server intended to:
1) Provide a minimal, deterministic WebSocket endpoint compatible with the Action Cable protocol (JSON messages),
2) Run with AnyCable (drop-in replacement for Action Cable) to validate and load-test external clients (e.g., Android ActionCable client),
3) Offer a small set of sample channels and actions (subscribe, broadcast, echo, presence) suitable for automated tests and local debugging.

AnyCable is used to run Action Cable–compatible real-time features at scale and supports most Action Cable features. The protocol is JSON-based and AnyCable implements an extended version of the protocol for improved consistency guarantees.  
References: AnyCable on Rails + Action Cable protocol docs. 

## Tech Stack (source of truth)
- Runtime: Ruby (latest stable supported by Rails 8.1.x)
- Framework: Ruby on Rails 8.1.x (target: Rails 8.1.2)
- Real-time: Action Cable semantics, served via AnyCable
- Transport: WebSocket endpoint `/cable`
- Storage (dev/test): SQLite (default) or PostgreSQL (preferred for CI)
- Background jobs: Active Job (async in dev, adapter selectable)
- Serialization: JSON (Action Cable protocol messages)
- Testing: RSpec (preferred) or Minitest (if already scaffolded), plus request/system tests for WebSocket behavior
- Tooling:
  - Standard Ruby linting/formatting (RuboCop if present)
  - Docker Compose optional for running AnyCable-Go + Redis (if needed)

## Repo Layout (expected)
- app/channels/
  - application_cable/connection.rb
  - application_cable/channel.rb
  - test_channel.rb
  - presence_channel.rb
- app/services/realtime/
  - broadcast_service.rb (optional)
  - auth_token.rb (optional)
- config/
  - cable.yml (if Action Cable config is used)
  - anycable.yml (if generated)
  - environments/development.rb (Action Cable URL points to AnyCable)
- spec/ (or test/)
  - channels/
  - requests/
  - support/websocket_helpers.rb

If the actual structure differs, follow existing conventions; do not introduce a second competing pattern.

## Primary Functional Requirements
Implement the following features for client testing:

### 1) WebSocket endpoint
- Provide `/cable` endpoint compatible with Action Cable protocol.
- Support standard lifecycle:
  - connect
  - subscribe/unsubscribe
  - perform actions
  - receive broadcasts

### 2) Sample channels
Create minimal channels:

#### TestChannel
- Purpose: deterministic echo + broadcast for client integration tests.
- Subscriptions:
  - `stream_from "test:global"`
  - optionally `stream_for current_user` when auth is enabled
- Actions:
  - `echo(payload:)` -> transmit same payload back to subscriber
  - `broadcast(message:)` -> broadcast to `test:global`

#### PresenceChannel
- Purpose: basic presence tracking for multi-client tests.
- On subscribed: broadcast `join` event to `presence:global`
- On unsubscribed: broadcast `leave` event
- Action:
  - `ping(ts:)` -> transmit ack + server timestamp

### 3) Authentication (optional but recommended)
Provide a simple, well-documented auth mode:
- Token in query param: `?token=...` OR header `Authorization: Bearer ...`
- In `ApplicationCable::Connection`, identify `current_user` (or `current_client_id`) from token
- Include an ENV toggle:
  - `AUTH_MODE=none|token`
- When `AUTH_MODE=token`, reject connection if token missing/invalid.

Keep it intentionally simple; do not build a full user system unless required.

## AnyCable Integration Requirements
Use AnyCable as the real-time server runtime:
- AnyCable is expected to work as a drop-in replacement for Action Cable in Rails.
- Use the AnyCable Rails setup generator whenever possible:
  - `rails g anycable:setup` (interactive) to produce required config for development/production.
- AnyCable-Go runs as a separate process and connects to the Rails RPC server (gRPC) by default.
- Development setup must include:
  - Rails app (HTTP)
  - Rails RPC server (AnyCable RPC endpoint)
  - AnyCable-Go server (WebSocket endpoint)

## Local Development: Commands
Codex should prefer these commands (in order) when validating changes:

### Setup
- `bundle install`
- `bin/rails db:prepare`

### Run (recommended: 3 processes)
- Terminal 1 (Rails web): `bin/rails server -p 3000`
- Terminal 2 (Rails RPC): `bundle exec anycable` (or the command provided by the setup generator)
- Terminal 3 (AnyCable-Go): `anycable-go` (use the args/config produced by setup)

If Docker Compose exists, prefer:
- `docker compose up --build`

### Tests & Quality
- `bin/rails test` OR `bundle exec rspec`
- `bundle exec rubocop` (if configured)

## Protocol Expectations (Action Cable)
- Client/server exchange is JSON-based per Action Cable protocol.
- Support subscribe messages and server confirmations (connected/confirm_subscription/reject_subscription).
- Incoming “perform” actions must route to channel action methods and transmit responses.
- For deterministic tests: ensure payload keys and response envelopes are stable.

## Engineering Rules (must follow)
- Keep the server minimal and deterministic; it is a test harness.
- Prefer explicit configuration over “magic.”
- Keep real-time logic inside `app/channels` and thin service objects in `app/services/realtime`.
- Avoid adding heavy dependencies unless necessary for AnyCable operation.
- Do not leak secrets; never log raw tokens.
- Provide README snippets for how to connect via a generic Action Cable client.

## How Codex Should Work in This Repo
When adding or changing functionality:
1) Update channel code and connection logic first.
2) Add/adjust tests that validate:
   - subscription success/rejection
   - echo round-trip
   - broadcast fan-out to multiple subscribers
3) Ensure local run instructions still work (3-process or Docker Compose).
4) Keep changes small and reviewable.

## Deliverables Checklist (for any task)
- [ ] Updated/added channels with clear actions
- [ ] Tests for channel behavior (subscribe, perform, receive)
- [ ] Updated config (AnyCable + Action Cable URL)
- [ ] README snippet for client connection and channel identifiers