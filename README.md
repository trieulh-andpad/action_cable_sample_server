# Rails + AnyCable ActionCable Protocol Test Server

This repo provides a minimal Rails 8.1 + AnyCable server that exposes a `/cable` WebSocket endpoint compatible with the Action Cable JSON protocol. It is designed as a deterministic test harness for Action Cable clients.

## Purpose
- Reference Action Cable protocol server
- AnyCable WebSocket runtime
- Sample channels for echo, broadcast, and presence
- Optional token auth for deterministic client tests

## Tech Stack
- Ruby 3.3.x
- Rails 8.1.x (target 8.1.2)
- AnyCable (anycable-rails + anycable-go)
- SQLite (dev/test)
- RSpec

## WebSocket Endpoint
- Path: `/cable`
- Default URL (AnyCable-Go): `ws://localhost:8080/cable`

## Channels
### TestChannel
- stream_from `test:global`
- action `echo(payload:)` -> transmit payload back
- action `broadcast(message:)` -> broadcast to `test:global`

### PresenceChannel
- stream_from `presence:global`
- on subscribe: broadcast `{ type: "join" }`
- on unsubscribe: broadcast `{ type: "leave" }`
- action `ping(ts:)` -> transmit `pong` with server time
- action `broadcast(message:)` -> broadcast to `presence:global`

## Authentication (optional)
Controlled by env:

```
AUTH_MODE=none   # default
AUTH_MODE=token
AUTH_TOKEN=test-token
```

When `AUTH_MODE=token`, the connection must include a token via:
- Query param `?token=...`
- Header `Authorization: Bearer ...`

---

## Build

### Prereqs (local)
- Ruby 3.3.x (recommended via rbenv)
- Bundler
- AnyCable-Go binary (macOS: `brew install anycable-go`)

### Install dependencies

```
bundle install
bin/rails db:prepare
```

---

## Run

### Local (3 processes)

Terminal 1:
```
bin/rails server -p 3000
```

Terminal 2:
```
bundle exec anycable
```

Terminal 3:
```
anycable-go --config ./anycable.toml
```

### Docker Compose (recommended)

```
docker compose up --build
```

WebSocket endpoint: `ws://localhost:8080/cable`
Redis is included in Compose to support AnyCable-Go.
RPC is bound on `0.0.0.0:50051` in the container so AnyCable-Go can authenticate subscriptions.
The Rails/AnyCable RPC containers use `ANYCABLE_HTTP_BROADCAST_URL=http://anycable-go:8080/_broadcast` to deliver broadcasts to AnyCable-Go.

---

## Test the WebSocket

You can use any Action Cable client. For a quick manual test, use `wscat` or `websocat`.

### Quick test (verified)

Install `websocat` if needed:

```
brew install websocat
```

Then send a subscribe + echo sequence:

```
{ printf '%s\n' \
  '{"command":"subscribe","identifier":"{\"channel\":\"TestChannel\"}"}' \
  '{"command":"message","identifier":"{\"channel\":\"TestChannel\"}","data":"{\"action\":\"echo\",\"payload\":{\"hello\":\"world\"}}"}'; \
  sleep 1; } | websocat -v -n ws://localhost:8080/cable
```

Expected output (example):

```
{"type":"welcome","sid":"..."}
{"identifier":"{\"channel\":\"TestChannel\"}","type":"confirm_subscription"}
{"identifier":"{\"channel\":\"TestChannel\"}","message":{"type":"echo","payload":{"hello":"world"}}}
```

AnyCable will also emit periodic `ping` frames while the connection remains open.

### Interactive example with `wscat`

```
# connect
wscat -c ws://localhost:8080/cable

# subscribe to TestChannel
{"command":"subscribe","identifier":"{\"channel\":\"TestChannel\"}"}

# echo
{"command":"message","identifier":"{\"channel\":\"TestChannel\"}","data":"{\"action\":\"echo\",\"payload\":{\"hello\":\"world\"}}"}

# broadcast
{"command":"message","identifier":"{\"channel\":\"TestChannel\"}","data":"{\"action\":\"broadcast\",\"message\":\"hi everyone\"}"}

# unsubscribe
{"command":"unsubscribe","identifier":"{\"channel\":\"TestChannel\"}"}
```

### Broadcast test with two clients (`wscat`)

Open two terminals.
If you are running via Docker Compose, make sure you've restarted after updates:
```
docker compose up -d --build
```

Terminal A:
```
wscat -c ws://localhost:8080/cable
{"command":"subscribe","identifier":"{\"channel\":\"TestChannel\"}"}
```

Terminal B:
```
wscat -c ws://localhost:8080/cable
{"command":"subscribe","identifier":"{\"channel\":\"TestChannel\"}"}
{"command":"message","identifier":"{\"channel\":\"TestChannel\"}","data":"{\"action\":\"broadcast\",\"message\":\"hello from B\"}"}
```

Expected: both terminals receive the broadcast message:
```
{"identifier":"{\"channel\":\"TestChannel\"}","message":{"type":"broadcast","message":"hello from B"}}
```

Expected responses (examples):

```
{"type":"welcome"}
{"type":"confirm_subscription","identifier":"{\"channel\":\"TestChannel\"}"}
{"message":{"type":"echo","payload":{"hello":"world"}}}
```

PresenceChannel example:

```
{"command":"subscribe","identifier":"{\"channel\":\"PresenceChannel\"}"}
{"command":"message","identifier":"{\"channel\":\"PresenceChannel\"}","data":"{\"action\":\"ping\",\"ts\":123}"}
{"command":"message","identifier":"{\"channel\":\"PresenceChannel\"}","data":"{\"action\":\"broadcast\",\"message\":\"hello from B\"}"}
```

---

## Tests

```
bundle exec rspec
```

---

## License

This project is released under the [MIT License](LICENSE).
