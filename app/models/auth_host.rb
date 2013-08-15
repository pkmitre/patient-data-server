require "uri"

class AuthHost
   include Singleton

   def initialize
     @config = OpenStruct.new(OAUTH2_CONFIG.local_host)
   end

  def authorization_request_url(redirect_uri, use_https=false)
    query = {'client_id' => @config.client_id, 'client_secret' => @config.client_secret,
             'response_type' => 'code', 'redirect_uri' => redirect_uri,
             'scope' => "vitals"}.to_query
    path = @config.auth_code_path

    mode = use_https ? URI::HTTPS : URI::HTTP

    mode.build(host: @config.host, path: path, query: query, port: @config.port)      
  end
end