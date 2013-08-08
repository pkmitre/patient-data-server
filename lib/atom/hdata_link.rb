class HdataLink
	include SAXMachine

	attribute :type, :as => :content_type
	attribute :href, :as => :url

end