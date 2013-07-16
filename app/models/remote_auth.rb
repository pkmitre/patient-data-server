class RemoteAuth
  include Mongoid::Document
  
  embedded_in :user
  
  field :access_token, type: String
  field :refresh_token, type: String
  
  belongs_to :remote_data, class_name: "RemoteData"
  
  def fetch
    if access_token
      remote_data.fetch(access_token)
      true
    else
      false
    end
  end
end