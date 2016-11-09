module SslConfig
  extend ActiveSupport::Concern

  def ssl_configured?
    Rails.env.production?
  end
end
