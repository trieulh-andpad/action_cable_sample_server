require "rails_helper"

RSpec.describe TestChannel, type: :channel do
  before do
    stub_connection current_client_id: "test-client"
  end

  it "streams from test:global" do
    subscribe

    expect(subscription).to be_confirmed
    assert_has_stream "test:global"
  end

  it "echoes payload back to the subscriber" do
    subscribe

    perform :echo, payload: { "hello" => "world" }

    expect(transmissions.last).to eq(
      "type" => "echo",
      "payload" => { "hello" => "world" }
    )
  end

  it "broadcasts to test:global" do
    subscribe

    assert_broadcast_on("test:global", type: "broadcast", message: "hi everyone") do
      perform :broadcast, message: "hi everyone"
    end
  end
end
