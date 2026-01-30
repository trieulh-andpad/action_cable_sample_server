require "rails_helper"

RSpec.describe PresenceChannel, type: :channel do
  before do
    stub_connection current_client_id: "test-client"
  end

  it "broadcasts join on subscribe" do
    assert_broadcast_on("presence:global", type: "join") do
      subscribe
    end
  end

  it "broadcasts leave on unsubscribe" do
    subscribe

    assert_broadcast_on("presence:global", type: "leave") do
      unsubscribe
    end
  end

  it "responds to ping with pong and server_time" do
    subscribe

    perform :ping, ts: 123

    message = transmissions.last
    expect(message["type"]).to eq("pong")
    expect(message["client_ts"]).to eq(123)
    expect(message["server_time"]).to be_present
  end

  it "broadcasts messages to presence:global" do
    subscribe

    assert_broadcast_on("presence:global", type: "broadcast", message: "hello from B") do
      perform :broadcast, message: "hello from B"
    end
  end
end
