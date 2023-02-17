class Shortener::ShortenerController < ActionController::Metal
  include ActionController::StrongParameters
  include ActionController::Redirecting
  include ActionController::Instrumentation
  include Rails.application.routes.url_helpers
  include Shortener

  def show
    token = ::Shortener::ShortenedUrl.extract_token(params[:id])
    track = Shortener.ignore_robots.blank? || request.human?
    url   = url_fetch_with_token(token: token, additional_params: params, track: track)
    redirect_to url[:url], status: :moved_permanently
  end

  private
    def url_fetch_with_token(token: nil, additional_params: {}, track: true)
      shortened_url = ::Shortener::ShortenedUrl.unexpired.where(unique_key: token).first

      url = if shortened_url
        shortened_url.increment_usage_count if track
        ::Shortener::ShortenedUrl.merge_params_to_url(url: shortened_url.url, params: additional_params)
      else
        raise ActionController::RoutingError.new('Not Found')
      end

      { url: url, shortened_url: shortened_url }
    end
end
