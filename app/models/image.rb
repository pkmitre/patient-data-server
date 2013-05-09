class Image
  include Mongoid::Document
  belongs_to :study
  field :series_description, type: String
  field :instance_number,    type: Integer
  field :data,               type: Moped::BSON::Binary
  # Convert the DICOM formatted data blob into a JPEG blob for display
  def jpeg
    i = Magick::Image.from_blob(data).first
    i.format = "JPG"
    i.to_blob
  end
end
