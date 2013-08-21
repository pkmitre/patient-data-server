class Record
  include Mongoid::Timestamps
  include Mongoid::Versioning

  embeds_many :studies

  # Given an array of dicom images, create an imaging study for this record
  def create_study(dicom_images)
    study = studies.create
    dicom_images.each do |dicom_image|
      dicom_object = DICOM::DObject.parse(dicom_image)
      study.description ||= dicom_object.value('0008,1030')
      study.images << Image.new(data: dicom_image.force_encoding('UTF-8'),
                                series_description: dicom_object.value('0008,103E'),
                                instance_number: dicom_object.value('0020,0013').to_i)
    end
    study.save
    touch # Need to force the timestamp to update
    save
  end

  # Temporary support for testing; load DICOM files from a directory into a study embedded in this record
  def load_study(directory)
    require 'find'
    imgages = []
    Find.find(directory).each do |path|
      next if FileTest.directory?(path)
      puts "Loading #{path}"
      images << File.read(path)
    end
    create_study images
  end

  #-------------------------------------------------------------------------
  # Find a set of entries in the given section and return them sorted
  # by the start_time or time, whichever is present for the given entry.
  def find_sorted_entries_by_timelimit(section, oldest,limit)
    # entries = record.send(section).any_of([:time.gt => e], [:start_time.gt => e]).limit(limit)
    entries = send(section).timelimit(oldest).limit(limit)
    now = Time.now
    recs = entries.to_a
    recs.sort! do |x, y|
      t1 = x.time || x.start_time || now.to_i
      t2 = y.time || y.start_time || now.to_i
      t2 <=> t1
    end
    recs
  end

  # Return recent vitals for use in helper methods, presorted by time descending
  def get_recent_vitals
    earliest = 2.years.ago
    vital_signs.timelimit(earliest).desc(:time)
  end

  def to_xml(args)
    HealthDataStandards::Export::C32.new.export(self)
  end
  
end
