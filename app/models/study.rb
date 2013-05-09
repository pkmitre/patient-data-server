class Study
  include Mongoid::Document

  field :description, type: String

  embedded_in :record

  # Because DICOM files can be on the large side and there can be large numbers of them for an entry, we don't
  # embed them (so we don't run into the 16MB record limit)
  has_many :images

end
