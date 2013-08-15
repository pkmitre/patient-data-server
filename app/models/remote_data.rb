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

  def obtain_access_token(authorization_code, redirect_uri, use_https=false)
    auth = AuthHost.instance
    client = Rack::OAuth2::Client.new(
      :identifier => auth.client_id,
      :secret => auth.client_secret,
      :redirect_uri => redirect_uri,
      :host => auth.host,
      :token_endpoint => "/oauth/token",
      :port => auth.port,
      :scheme => use_https ? 'https' : 'http',
      :scope => auth.scope
    )

    client.authorization_code = authorization_code
    client.access_token!
  end

  private

  def download(remote_url, access_token)
    token = Rack::OAuth2::AccessToken::Bearer.new(:access_token => access_token)
    response = token.get(remote_url)

    entry = case response.contenttype
    when "application/atom+xml"
      download_atom_feed(response.content, access_token)
    when "application/xml"
     importer = SectionRegistry.instance.extension_from_path(self.data_type).importers['application/xml']
     doc = Nokogiri::XML(response.content)
     importer.import(doc)
    when "application/json"
      response.content
    when "application/dicom"
      Image.new(data: response.content)
    end
  end

  def content_type
    case data_type
    when "images"
      "application/dicom"
    else
      "application/xml"
    end
  end

  def persist_data(data)
    if data_type == "images" #dicom
      create_study(data)
    elsif data.is_a?(Hash) #json
      record.send(data_type).create(data)
    else
      record.send(data_type) << data #xml
    end
  end

  def create_study(images)
    study = record.studies.build
    if images.is_a?(Array)
      study.images.concat images
    else
      study.images << images
    end
    record.save!
  end

  def download_atom_feed(feed, token)
    # binding.pry
    Feedzirra::Feed.parse(feed).entries.map do |entry|
      download(entry.content_link.url, token)
    end
  end
end
