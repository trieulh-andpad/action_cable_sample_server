module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_client_id

    def connect
      if auth_mode_token?
        token = request.params["token"] || bearer_token
        reject_unauthorized_connection unless valid_token?(token)
        self.current_client_id = token
      else
        self.current_client_id = "anon"
      end
    end

    private

    def auth_mode_token?
      ENV.fetch("AUTH_MODE", "none") == "token"
    end

    def bearer_token
      header = request.headers["Authorization"].to_s
      header.start_with?("Bearer ") ? header.split(" ", 2).last : nil
    end

    def valid_token?(token)
      expected = ENV.fetch("AUTH_TOKEN", "test-token")
      token.present? &&
        expected.present? &&
        ActiveSupport::SecurityUtils.secure_compare(token, expected)
    end
  end
end
