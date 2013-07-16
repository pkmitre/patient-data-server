module OAuth2

  class TokenIntrospector
    include Singleton

    def initialize
      @oauth2 = OAUTH2_CONFIG.remote_hosts
    end

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
      token = JSON::JWT.decode(jwt)
      issuer = token['iss']
      introspection_endpoint = @oauth2[issuer]

      token_response = RestClient.post(introspection_endpoint, token: jwt)
      token_result = ActiveSupport::JSON.decode(token_response)
      token = OAuth2::Token.new(token_result)

      raise OAuth2::InvalidTokenException.new("Expired Token #{token_response}") unless token.active
    end
    
  end
end