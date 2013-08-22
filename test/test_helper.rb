ENV["RAILS_ENV"] = "test"
require 'cover_me'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'webmock/test_unit'

class ActiveSupport::TestCase
  
  def load_fixtures
    `mongoimport -d #{Mongoid.master.name} -h #{Mongoid.master.connection.host_to_try[0]} --drop -c records test/fixtures/records.json`
    `mongoimport -d #{Mongoid.master.name} -h #{Mongoid.master.connection.host_to_try[0]} --drop -c users test/fixtures/users.json`
    `mongoimport -d #{Mongoid.master.name} -h #{Mongoid.master.connection.host_to_try[0]} --drop -c clients test/fixtures/clients.json`
  end

  
  # Override config file for test
  ::OAUTH2_CONFIG = OpenStruct.new(local_host: { 'client_id' => 'client_id', 'client_secret' => 'client_secret' },
                                   remote_hosts: { 'https://test.com/' => { 'client_id' => 'client_id', 
                                                                            'client_secret' => 'client_secret', 
                                                                            'path' =>  '/oauth2/introspection'}})

  

end


def dump_database
   Mongoid.session(:default).collections.each do |collection|
     collection.drop unless collection.name.include?('system.')
   end
end

dump_database