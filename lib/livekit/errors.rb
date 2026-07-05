# frozen_string_literal: true

module LiveKit
  # Raised when a LiveKit server API call fails. Exposes the error code, message,
  # and any metadata the server attached.
  class ServerError < StandardError
    # @return [String] the error code, e.g. "not_found" or "permission_denied"
    attr_reader :code
    # @return [Hash{String=>String}] error metadata returned by the server
    attr_reader :metadata

    def initialize(code, message, metadata: {})
      @code = code
      @metadata = metadata || {}
      super(message)
    end

    # Builds a ServerError (or SipCallError) from the underlying error. Returns nil
    # when +err+ is nil, so it can be called directly on a response's error.
    # @return [LiveKit::ServerError, nil]
    def self.from(err)
      return nil if err.nil?

      meta = err.meta || {}
      klass = meta.key?("sip_status_code") ? SipCallError : self
      klass.new(err.code.to_s, err.msg, metadata: meta)
    end
  end

  # Raised when a SIP dialing call (create_sip_participant / transfer_sip_participant)
  # fails with a SIP response status. The SIP code and reason are exposed
  # directly; any other metadata remains available via {#metadata}.
  class SipCallError < ServerError
    # @return [Integer, nil] the SIP response code, e.g. 486 (Busy Here)
    def sip_status_code
      raw = metadata["sip_status_code"]
      raw && raw.to_i
    end

    # @return [String, nil] the SIP reason phrase, e.g. "Busy Here"
    def sip_status
      metadata["sip_status"]
    end

    # A clear, SIP-specific representation, including any extra metadata.
    def message
      code_str = metadata["sip_status_code"]
      return super if code_str.nil?

      reason = metadata["sip_status"]
      result = "SIP call failed: #{code_str}"
      result += " #{reason}" if reason && !reason.empty?
      result += " (#{code})"
      extra = metadata.reject { |k, _| %w[sip_status_code sip_status error_details].include?(k) }
      result += " [#{extra.map { |k, v| "#{k}=#{v}" }.join(", ")}]" unless extra.empty?
      result
    end
    alias to_s message
  end
end
