module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_client_id

    def connect
      log_all_headers
      token = access_token
      if token.blank?
        logger.warn "[Connection] REJECTED: missing X-ACCESS-TOKEN header"
        reject_unauthorized_connection
      end
      logger.info "[Connection] ACCEPTED: client_id=#{token}"
      self.current_client_id = token
    end

    private

    def access_token
      request.headers["HTTP_X_ACCESS_TOKEN"].presence
    end

    def log_all_headers
      logger.info "=" * 60
      logger.info "[Connection] NEW CONNECTION REQUEST"
      logger.info "=" * 60
      logger.info "[Connection] URL: #{request.url}"
      logger.info "[Connection] Origin: #{request.origin}"
      logger.info "[Connection] IP: #{request.remote_ip}"
      logger.info "-" * 60
      logger.info "[Connection] ALL HEADERS:"
      request.headers.env.each do |key, value|
        logger.info "[Connection]   #{key}: #{value}"
      end
      logger.info "=" * 60
    end
  end
end
