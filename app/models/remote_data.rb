
class RemoteData
  include Mongoid::Document

  field :url, type: String
  field :data_type, type: String
  
  belongs_to :record

  def fetch(access_token)
    token = Rack::OAuth2::AccessToken::Bearer.new(:access_token => access_token)
    response = token.get(url)
    case response.contenttype
   	when "application/xml"
   		
   	when "application/dicom"
   		record.images = Image.new(response.content)
   	else
   	end
  end

  def obtain_access_token(authorization_code, redirect_uri)
    client = Rack::OAuth2::Client.new(
      :identifier => vital_sign_host.client_id,
      :secret => vital_sign_host.client_secret,
      :redirect_uri => redirect_uri,
      :host => vital_sign_host.hostname,
      :token_endpoint => "/oauth/token",
      :port => vital_sign_host.port,
      :scheme => "http"
    )

    client.authorization_code = authorization_code
    client.access_token!
  end
end
