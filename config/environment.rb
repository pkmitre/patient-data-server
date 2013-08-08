# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
HdataServer::Application.initialize!

require_relative "../lib/hds/entry"
require_relative "../lib/hds/record"

OAUTH2_CONFIG = OpenStruct.new(YAML.load(File.open("config/oauth2.yml")))
UI_CONFIG = OpenStruct.new(YAML.load(File.open("config/ui.yml")))
Feedzirra::Feed.add_feed_class HdataFeed
