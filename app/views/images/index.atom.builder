atom_feed root_url: images_url(@record.medical_record_number, @study) do |feed|
  feed.title @study.description
  @images.each do |image|
    feed.entry(image, url: image_url(@record.medical_record_number, @study, image)) do |entry|
      entry.link rel: "alternate", type: 'application/dicom', href: image_url(@record.medical_record_number, @study, image, format: 'dcm')
      entry.title "#{image.series_description} ##{image.instance_number}"
      entry.series_description image.series_description
      entry.instance_number image.instance_number
    end
  end
end
