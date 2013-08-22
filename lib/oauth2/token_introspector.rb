module OAuth2

  class TokenIntrospector
    include Singleton

    def authorize(controller)
      token = extract_token(controller.request)
      object_type = controller.controller_name.singularize
      object = controller.instance_variable_get("@#{object_type}")
      fetch_authorization(token, object)
    end

    private

    def extract_token(request)
      if request.headers["Authorization"]
        jwt = request.headers['Authorization'].split(" ").last
      elsif request.params['token']
        jwt = request.params['token']
      else
        raise OAuth2::NoTokenFoundException.new("Unable to find token in header or params")
      end

      jwt
    end

    def fetch_authorization(jwt, object)
      token = JSON::JWT.decode(jwt, :skip_verification) #don't need to verify because the introspection endpoint does that for us
      issuer = token['iss']
      Rails.logger.info(issuer)
      issuer_uri = URI.parse(issuer)
      params = OAUTH2_CONFIG.remote_hosts[issuer].dup

      uri = URI::Generic.build(scheme: issuer_uri.scheme, host: issuer_uri.host, path: params.delete('path'), port: params.delete('port')).to_s
      token_response = RestClient.post(uri, params.merge(token: jwt))
      token_result = ActiveSupport::JSON.decode(token_response)
      token = OAuth2::Token.new(token_result)

      raise OAuth2::InvalidTokenException.new("Expired Token #{token_response}") unless token.active
    end
    
  end
end
