atom_feed do |feed|
  @studies.each do |study|
    feed.entry(study, url: images_url(@record.medical_record_number, study)) do |entry|
      entry.link rel: "alternate", type: Mime::Atom, href: images_url(@record.medical_record_number, study, format: :atom)
      entry.title study.description
    end
  end
end
