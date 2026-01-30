class PresenceChannel < ApplicationCable::Channel
  def subscribed
    stream_from "presence:global"
    ActionCable.server.broadcast("presence:global", { type: "join" })
  end

  def unsubscribed
    ActionCable.server.broadcast("presence:global", { type: "leave" })
  end

  def ping(data)
    transmit({ type: "pong", client_ts: data["ts"], server_time: Time.now.utc.iso8601 })
  end

  def broadcast(data)
    ActionCable.server.broadcast("presence:global", { type: "broadcast", message: data["message"] })
  end
end
