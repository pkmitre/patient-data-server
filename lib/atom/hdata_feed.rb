require "feedzirra"
require "sax-machine"

class HdataFeed
  include SAXMachine
  include Feedzirra::FeedUtilities
  element :title
  element :subtitle, :as => :description
  element :link, :as => :url, :value => :href, :with => {:type => "text/html"}
  element :link, :as => :feed_url, :value => :href, :with => {:type => "application/atom+xml"}
  elements :link, :as => :links, :value => :href
	elements :entry, :as => :entries, :class => HdataEntry

  def self.able_to_parse?(xml) #:nodoc:
    /\<feed[^\>]+xmlns=[\"|\'](http:\/\/www\.w3\.org\/2005\/Atom|http:\/\/purl\.org\/atom\/ns\#)[\"|\'][^\>]*\>/ =~ xml
  end

end