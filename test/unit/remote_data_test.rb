require 'test_helper'

class RemoteDataTest < ActiveSupport::TestCase

  setup do
    @record = FactoryGirl.create(:record)
    @data = RemoteData.new(url: "www.example.com", data_type: "studies", record: @record)
    @data.record = @record
    @image = File.open("test/fixtures/sample.dcm")
  end

  test "download image" do
   
    stub_request(:get, "www.example.com").to_return(body: @image.read, headers: {'Content-Type' => 'application/dicom'})
    @data.fetch("fake token")

    study = @record.studies.first
    assert_not_nil study

    assert_not_nil study.images.first
  end

  test "download atom feed of images" do
   
    atom_file = File.open("test/fixtures/atom/dicom.xml")
    stub_request(:get, "www.example.com").to_return(body: atom_file.read, headers: {'Content-Type' => 'application/atom+xml'})
    stub_request(:get, /localhost.*/).to_return(body: @image.read, headers: {'Content-Type' => 'application/dicom'})
    
    @data.fetch("fake_token")

    study = @record.studies.first
    assert_not_nil study
    assert_equal 2, study.images.size

  end

  test "download atom feed of xml" do
   
    atom_file = File.open("test/fixtures/atom/lab_result.xml")
    stub_request(:get, "www.example.com").to_return(body: atom_file.read, headers: {'Content-Type' => 'application/atom+xml'})
    stub_request(:get, /localhost.*/).to_return(body: @image.read, headers: {'Content-Type' => 'application/dicom'})
    
    @data.fetch("fake_token")

    study = @record.studies.first
    assert_not_nil study
    assert_equal 2, study.images.size
  end

  test "download xml" do
    assert_nil @record.results.first
    @data.update_attribute(:data_type, "results")
    lab = FactoryGirl.build(:lab_result)
    extension = SectionRegistry.instance.extension_from_path("results")
    exporter = extension.exporters['application/xml']
    output = exporter.export(lab)
    stub_request(:get, "www.example.com").to_return(body: output, headers: {'Content-Type' => 'application/xml'})
    @data.fetch("fake token")
    assert_equal 1, @record.results.size
  end

  test "download json" do
    assert_nil @record.results.first
    @data.update_attribute(:data_type, "results")
    lab = FactoryGirl.build(:lab_result)
    stub_request(:get, "www.example.com").to_return(body: lab.attributes, headers: {'Content-Type' => 'application/json'})
    @data.fetch("fake token")
    assert_not_nil @record.results.first
  end

end
