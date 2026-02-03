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
- Default URL (AnyCable-Go): `wss://localhost:8080/cable`

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

## Authentication (required)

All WebSocket connections must include a non-empty `X-ACCESS-TOKEN` header. Connections without this header will be rejected.

Example with wscat:
```bash
wscat -c wss://localhost:8080/cable --no-check -H "X-ACCESS-TOKEN: your-token-here"
```

The token value can be any non-empty string. The server uses it as the client identifier.

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

WebSocket endpoint: `wss://localhost:8080/cable`
Redis is included in Compose to support AnyCable-Go.
RPC is bound on `0.0.0.0:50051` in the container so AnyCable-Go can authenticate subscriptions.
The Rails/AnyCable RPC containers use `ANYCABLE_HTTP_BROADCAST_URL=http://anycable-go:8080/_broadcast` to deliver broadcasts to AnyCable-Go.

---

## SSL Configuration (Local Development)

For local development, you need to generate self-signed SSL certificates to enable `wss://`. The certificate files are **not included in the repository** and must be generated locally.

### Generate SSL Certificates (Required)

Before running Docker Compose for the first time, generate self-signed certificates:

```bash
mkdir -p config/ssl

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout config/ssl/anycable.key \
  -out config/ssl/anycable.crt \
  -subj "/C=US/ST=Dev/L=Local/O=Dev/CN=localhost" \
  -addext "subjectAltName=DNS:localhost,IP:127.0.0.1"
```

This creates:
- `config/ssl/anycable.crt` - SSL certificate (valid for 365 days)
- `config/ssl/anycable.key` - SSL private key

> **Note:** These files are in `.gitignore` and will not be committed to version control.

### How It Works

The `docker-compose.yml` mounts the project directory into the `anycable-go` container and configures SSL via environment variables:
- `ANYCABLE_SSL_CERT=/app/config/ssl/anycable.crt`
- `ANYCABLE_SSL_KEY=/app/config/ssl/anycable.key`

### Regenerating Certificates

If your certificates expire or you need to regenerate them, simply run the `openssl` command above again.

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
  sleep 1; } | websocat -v -n --insecure wss://localhost:8080/cable
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
wscat -c wss://localhost:8080/cable --no-check

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
wscat -c wss://localhost:8080/cable --no-check
{"command":"subscribe","identifier":"{\"channel\":\"TestChannel\"}"}
```

Terminal B:
```
wscat -c wss://localhost:8080/cable --no-check
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
