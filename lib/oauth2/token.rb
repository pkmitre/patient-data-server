module OAuth2
  class Token

    attr_reader :scopes, :active
    
    def initialize(token_hash)
        @active = token_hash['active']
        @scopes = token_hash['scope'].try(:split, ' ') || []
    end

    def valid_for(object)
      self.can? :show, object
    end
    
  end
end
