module SslConfig
  extend ActiveSupport::Concern

  def ssl_configured?
    ENV.fetch('SSL_CONFIGURED', 'false').eql?('true')
  end
end
