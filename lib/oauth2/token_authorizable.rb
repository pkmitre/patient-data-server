module OAuth2
  module TokenAuthorizable

  	def self.included(receiver)
  		receiver.before_filter :check_oauth2_authorization
  		receiver.skip_before_filter :authenticate_user!
  		receiver.skip_before_filter :verify_authenticity_token
  	end

    def check_oauth2_authorization
      OAuth2::TokenIntrospector.instance.authorize(self) unless current_user
    rescue OAuth2::NoTokenFoundException
      authenticate_user!
    end

  end
end