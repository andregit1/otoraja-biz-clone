class PollingHistory < ApplicationRecord
  enum poll: {whats_app_outbound_messages: 0, whats_app_inbound_messages: 1}
end
  