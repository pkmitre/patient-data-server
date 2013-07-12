class Entry
  include Mongoid::Timestamps
  include Mongoid::Versioning

  embeds_one :document_metadata, class_name: "Metadata::Base"
  
  def permission_type
    self.class.name.underscore
  end

  class << self
    def timelimit(oldest)
      any_of([:time.gt => oldest], [:start_time.gt => oldest])
    end
  end

end