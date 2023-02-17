module Otoraja
  class ShortUrl
    class << self
      include Rails.application.routes.url_helpers
    end

    def self.generate_short_url(url, force = false)
      if Rails.env.in?(['production', 'staging']) || force
        domain = ENV['SHORT_URL_DOMAIN']
        unique_key = Shortener::ShortenedUrl.generate(url).unique_key
        "https://#{domain}#{shortener_path(unique_key)}"
      else
        # ローカルでは短縮をしない
        url
      end
    end
  end
end
