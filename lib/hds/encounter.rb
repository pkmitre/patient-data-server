class Encounter < Entry

  # Because DICOM files can be on the large side and there can be large numbers of them for an entry, we don't
  # embed them (so we don't run into the 16MB record limit)
  has_many :dicom_files

  # Temporary support for testing; load DICOM files from a directory into this encounter
  def load_dicom_files(directory)
    require 'find'
    Find.find(directory).each do |path|
      next if FileTest.directory?(path)
      puts "Loading #{path}"
      dicom_file = File.read(path)
      dicom_object = DICOM::DObject.parse(dicom_file)
      dicom_files << DicomFile.new(data: dicom_file,
                                   study_description: dicom_object.value('0008,1030'),
                                   series_description: dicom_object.value('0008,103E'),
                                   instance_number: dicom_object.value('0020,0013').to_i)
    end

  end
end
