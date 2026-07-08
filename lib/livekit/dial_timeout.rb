# frozen_string_literal: true

module LiveKit
  # Request-timeout handling shared by calls that may block until a call is
  # answered (SIP CreateSIPParticipant/TransferSIPParticipant, WhatsApp
  # AcceptWhatsAppCall). These take longer than a normal request, and the request
  # must outlast the wait or it would abort before the call can be answered.
  module DialTimeout
    # Ring window (seconds) assumed when a request doesn't set a ringing timeout;
    # matches the server default. A dialing request must outlast it.
    DEFAULT_RINGING_TIMEOUT = 30
    # Keep the request timeout at least this many seconds above the ringing
    # timeout, so the request doesn't abort before the call can be answered.
    RINGING_TIMEOUT_MARGIN = 2

    # Request timeout (seconds): the ring window plus a margin, so the request
    # doesn't abort before the call can be answered. The ring window is
    # +ringing_timeout+ (seconds) when set, else DEFAULT_RINGING_TIMEOUT. A longer
    # user-supplied +timeout+ is honored; a shorter one is raised to the floor.
    def self.resolve(timeout, ringing_timeout)
      ring = ringing_timeout || DEFAULT_RINGING_TIMEOUT
      floor = ring + RINGING_TIMEOUT_MARGIN
      [timeout || floor, floor].max
    end
  end
end
