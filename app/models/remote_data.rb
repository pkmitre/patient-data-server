class RemoteData
  include Mongoid::Document

  field :url, type: String
  field :data_type, type: String
  field :atom, type: Boolean
  
  belongs_to :record

  def fetch(access_token)
    result = download(self.url, access_token)
    persist_data(result)
  end

  def obtain_access_token(authorization_code, redirect_uri)
    auth = AuthHost.instance
    client = Rack::OAuth2::Client.new(
      :identifier => auth.client_id,
      :secret => auth.client_secret,
      :redirect_uri => redirect_uri,
      :host => auth.host,
      :token_endpoint => auth.token_endpoint,
      # :port => auth.port,
      :scheme => "http",
      :scope => auth.scope
    )
    
    client.authorization_code = authorization_code
    client.access_token!
  end

  private

  def download(remote_url, access_token)
    token = Rack::OAuth2::AccessToken::Bearer.new(:access_token => access_token)

    response = token.get(remote_url)

    entry = case response.content_type
            when %r{application/atom}
              download_atom_feed(response.content, access_token)
            when %r{application/xml}
              importer = SectionRegistry.instance.extension_from_path(self.data_type).importers['application/xml']
              doc = Nokogiri::XML(response.content)
              importer.import(doc)
            when %r{application/json}, %r{application/dicom}
              response.content
            end
  end

  def persist_data(data)
    if data_type == "studies" #dicom
      record.create_study(data)
    elsif data.is_a?(Hash) #json
      record.send(data_type).create(data)
    else
      record.send(data_type) << data #xml
    end
  end

  def download_atom_feed(feed, token)
    Feedzirra::Feed.parse(feed).entries.map do |entry|
      download(entry.content_link.url, token)
    end
  end
end
