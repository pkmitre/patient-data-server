atom_feed "xmlns:hrf-md" => "http://projecthdata.org/hdata/schemas/2009/11/metadata" do |feed|
  @entries.each do |entry|
    feed.entry(entry, url: section_document_path(@record.medical_record_number, @section_name, entry.id), type: "application/xml") do |atom_entry|
      atom_entry.link(rel: "alternate", type: Mime::XML, href: section_document_path(@record.medical_record_number, @section_name, entry))
      atom_entry.link(rel: "alternate", type: Mime::Json, href: section_document_path(@record.medical_record_number, @section_name, entry))
      if entry.document_metadata
        atom_entry.content(type: 'xml') do |content|
          content << HealthDataStandards::Export::Hdata::Metadata.new.export(entry, entry.document_metadata)
        end
      end
    end
  end
end