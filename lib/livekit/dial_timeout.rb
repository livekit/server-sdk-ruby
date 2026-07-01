# frozen_string_literal: true

module LiveKit
  # Request-timeout handling shared by calls that dial a phone and wait for an
  # answer (SIP CreateSIPParticipant/TransferSIPParticipant, WhatsApp
  # AcceptWhatsAppCall). These take longer than a normal request, and the request
  # must outlast ringing or it would abort before the call can be answered.
  module DialTimeout
    # Default request timeout (seconds) for calls that dial a phone.
    DIAL_TIMEOUT = 30
    # Keep the request timeout at least this many seconds above the ringing
    # timeout, so the request doesn't abort before the call can be answered.
    RINGING_TIMEOUT_MARGIN = 2

    # Request timeout (seconds): a user-supplied value (or the dial default)
    # raised, when needed, to stay at least RINGING_TIMEOUT_MARGIN above the
    # ringing timeout (also in seconds; nil when unset).
    def self.resolve(timeout, ringing_timeout)
      effective = timeout || DIAL_TIMEOUT
      effective = [effective, ringing_timeout + RINGING_TIMEOUT_MARGIN].max if ringing_timeout
      effective
    end
  end
end
