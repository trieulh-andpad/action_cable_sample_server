class TestChannel < ApplicationCable::Channel
  def subscribed
    stream_from "test:global"
  end

  def echo(data)
    transmit({ type: "echo", payload: data["payload"] })
  end

  def broadcast(data)
    ActionCable.server.broadcast("test:global", { type: "broadcast", message: data["message"] })
  end
end
