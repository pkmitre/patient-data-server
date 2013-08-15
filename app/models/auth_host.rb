require "uri"

class AuthHost
  include Singleton


  attr_reader :client_id, :client_secret, :host, :token_endpoint, :auth_endpoint, :port

  def initialize
    config = OpenStruct.new(OAUTH2_CONFIG.local_host)
    @client_id = config.client_id
    @client_secret = config.client_secret
    @host = config.host
    @token_endpoint = config.token_path
    @auth_endpoint = config.authorization_path
    @port = config.port
  end

  def authorization_request_url(redirect_uri, use_https=false)
    query = {'client_id' => @client_id, 'client_secret' => @client_secret,
             'response_type' => 'code', 'redirect_uri' => redirect_uri,
             'scope' => "vitals"}.to_query
    path = @auth_endpoint

    mode = use_https ? URI::HTTPS : URI::HTTP

    mode.build(host: @host, path: path, query: query, port: @port)      
  end
end