class DataController < ApplicationController

  before_filter :find_record, except: [:access_code]

  def create
    data = RemoteData.new(params[:remote_data])
    data.record = @record
    data.save

    auth = current_user.auth_for_feed(data)
    
    if auth.fetch
      flash[:notice] = "Imported new data"
      redirect_to record_path(@record.medical_record_number)
    else
      redirect_to AuthHost.instance.authorization_request_url(data_access_code_url, Rails.env.production?).to_s
    end
  end

  def access_code
    # The way we pair up the access code sent back from the resource host with a feed
    # is by looking for the first VitalSignAuth without an access_token. In theory,
    # we should be able to use the state parameter as described in OAuth 2, but it
    # looks like Rack::OAuth2 doesn't support it. This code should work assuming the
    # same user doesn't try to gain access to two different vital sign feeds at the
    # same time.

    auth = current_user.remote_auths.where(access_token: nil).first
    
    access_token = auth.remote_data.obtain_access_token(params[:code], 
                                                        url_for(controller: 'data',action: 'access_code'), 
                                                        Rails.env.production?)

    auth.access_token = access_token.access_token
    auth.refresh_token = access_token.refresh_token
    auth.save!
    
    auth.fetch
    
    
    redirect_to record_path(auth.remote_data.record.medical_record_number)
  end
  
end
