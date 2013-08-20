require "feedzirra"

class HdataEntry < Feedzirra::Parser::AtomEntry
  include SAXMachine
  include Feedzirra::FeedEntryUtilities
	elements :link, :as => :links, :class => HdataLink
	element :content

	def content_link
		links.detect { |l| l.content_type != "text/html"}
	end
end