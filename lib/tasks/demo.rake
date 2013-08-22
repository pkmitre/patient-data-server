namespace :demo do
  
  desc "Setup the CSIS demo server"
  task setup_csis: ['db:purge', :add_patient, :add_images]

  desc "Setup the USAFA demo server"
  task setup_usafa: ['db:purge', :add_patient]

  task :add_patient => :environment do
    puts "Creating record for Randall Jones"
    Record.create title: 'MSgt.', first: 'Randall', last: 'Jones', gender: 'M', birthdate: '1972-07-14', medical_record_number: '9999069'
  end

  task :add_images => :environment do
    images_path = File.join(Rails.root, 'public', 'system', 'dicom-images')
    if File.directory?(images_path)
      puts "Importing images for Randal Jones"
      record = Record.where(medical_record_number: '9999069').first
      record.load_study(images_path)
    else
      puts "Cannot find MRI images to import for Randal Jones"
    end
  end

end
