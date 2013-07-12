module OAuth2
  module TokenAuthorizable

    def check_oauth2_authorization
      OAuth2::TokenIntrospector.instance.authorize(self) unless current_user
    rescue OAuth2::NoTokenFoundException
      authenticate_user!
    end

  end
end