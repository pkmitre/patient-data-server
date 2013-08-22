require 'test_helper'
require 'atom_test'

class EntriesControllerTest < AtomTest
  include Devise::TestHelpers
  
  setup do
    @record = FactoryGirl.create(:record, :with_lab_results)
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  test "get result w/ oauth2" do

    sign_out @user

    claim = {iss: 'https://test.com/', scope: %w(data images), exp: 1.week.from_now, nbf: Time.now}
    token = JSON::JWT.new(claim).to_s

    stub_request(:post, "https://test.com/oauth2/introspection").to_return(body: "{\"active\": true, \"scope\": \"data\"}")
    request.env['HTTP_ACCEPT'] = Mime::XML

    get :show, {record_id: @record.medical_record_number, section: 'results', id: @record.results.first.id, token: token}
    assert_response :success
  end

  test "unauthorized access" do
    sign_out @user
    request.env['HTTP_ACCEPT'] = Mime::XML
    get :show, {record_id: @record.medical_record_number, section: 'results', id: @record.results.first.id}
    assert_response :unauthorized
  end
  
  test "get a result as xml" do
    request.env['HTTP_ACCEPT'] = Mime::XML
    get :show, {record_id: @record.medical_record_number, section: 'results', id: @record.results.first.id}
    doc = Nokogiri::XML::Document.parse(response.body)
    assert_response :success
    assert_equal "result", doc.children.first.name
  end
  
  test "get a result as JSON" do
    request.env['HTTP_ACCEPT'] = Mime::JSON
    get :show, {record_id: @record.medical_record_number, section: 'results', id: @record.results.first.id}
    doc = JSON.parse(response.body)
    assert_response :success
    assert_equal "LDL Cholesterol", doc['description']
  end
  
  test "get a section that doesn't exist" do
    request.env['HTTP_ACCEPT'] = Mime::XML
    get :show, {record_id: @record.medical_record_number, section: 'bacon', id: @record.results.first.id}
    assert_response :missing
  end
  
  test "get section Atom feed" do
    request.env['HTTP_ACCEPT'] = 'application/atom+xml'
    get :index, {record_id: @record.medical_record_number, section: 'results'}
    assert_response :success
    assert_atom_success
    rss = atom_results
    assert_atom_result_count rss, 1
    assert rss.entries[0].content_link.url.include? "/records/#{@record.medical_record_number}/results/#{@record.results.first.id}"
  end

  test "test metadata" do
     result = @record.results.first
     result.build_document_metadata
     pedigree = Metadata::Pedigree.new(organization: "something")
     pedigree.build_author(name: "Steve")
     result.document_metadata.pedigrees << pedigree
     HealthDataStandards::Export::Hdata::Metadata.new.export(result, result.document_metadata)
  end
  
  test "post a new result section document" do
    assert_equal 1, @record.results.count
    result_file = File.read(Rails.root.join('test/fixtures/result.xml'))
    request.env['RAW_POST_DATA'] = result_file
    request.env['CONTENT_TYPE'] = 'application/xml'
    post :create, {record_id: @record.medical_record_number, section: 'results'}
    assert_response 201
    assert response['Location'].present?
    @record.reload
    assert_equal 2, @record.results.count
    result = @record.results[1]
    assert_equal 135, result.values.first.scalar
  end

  # need to add JSON support
  # test "post a new result section document as json" do
  #   assert_equal 1, @record.results.count

  #   request.env['RAW_POST_DATA'] = {description: "Cholesterol", 
  #                                   time: 1285387200, 
  #                                   codes: {'CPT' => ['83721'], 'LOINC' => ['2089-1'], 
  #                                   reference_range: '70 mg/dL - 160 mg/dL'}}.to_json

  #   request.env['CONTENT_TYPE'] = 'application/json'
  #   post :create, {record_id: @record.medical_record_number, section: 'results'}
  #   assert_response 201
  #   assert response['Location'].present?
  #   @record.reload
  #   assert_equal 2, @record.results.count
  #   result = @record.results[1]
  #   assert_not_nil result
  # end

  test "post a new result section document w/metadata" do
    # result_file = File.read(Rails.root.join('test/fixtures/result.xml'))
    # metadata_file = Rack::Test::UploadedFile.new(Rails.root.join('test/fixtures/metadata.xml'), "application/xml")
    metadata_file = fixture_file_upload("test/fixtures/metadata.xml", "application/xml")
    result_file = fixture_file_upload("test/fixtures/result.xml", "application/xml")
    request.env['CONTENT_TYPE'] = 'multipart/form-data'
    post :create, {record_id: @record.medical_record_number, section: 'results', metadata: metadata_file, content: result_file}

    @record.reload
    result = @record.results[1]

    assert_not_nil result.document_metadata
    assert_response 201
  end

  test "update metadata" do
    result = @record.results.first
    result.create_document_metadata
    request.env['RAW_POST_DATA'] = File.read(Rails.root.join('test/fixtures/metadata.xml'))
    post :update_metadata, {record_id: @record.medical_record_number, section: 'results', id: result.id}
    result.reload
    assert_equal "Sample Provider, Inc.", result.document_metadata.pedigrees.first.organization
  end
  
  test "update a lab result" do
    result_file = File.read(Rails.root.join('test/fixtures/result.xml'))
    result = @record.results.first
    request.env['RAW_POST_DATA'] = result_file
    request.env['CONTENT_TYPE'] = 'application/xml'
    put :update, {record_id: @record.medical_record_number, section: 'results', id: result.id}
    assert_response :success
    result.reload
    assert_equal 135, result.values.first.scalar
  end

  test "delete a result" do
    assert_equal 1, @record.results.count
    delete :delete, {record_id: @record.medical_record_number, section: 'results', id: @record.results.first.id}
    assert_response 204
    @record.reload
    assert_equal 0, @record.results.count
  end
  
  test "get a document that doesn't exist" do
    request.env['HTTP_ACCEPT'] = Mime::XML
    get :show, {record_id: @record.medical_record_number, section: 'results', id: 'bacon'}
    assert_response 404
    
    get :show, {record_id: @record.medical_record_number, section: 'results', id: ('0' * 24)}
    assert_response :missing
  end

  test "check for 404 on non-existent record on index" do
    get :index, :record_id => "AAAA", section: "AAAA"
    assert_response :missing
  end

  test "check for 404 on non-existent record on show" do
    get :show, :record_id => "AAAA", section: "AAAA"
    assert_response :missing
  end

  test "check for 404 on non-existent record on update" do
    get :update, :record_id => "AAAA", section: "AAAA"
    assert_response :missing
  end

  test "check for 404 on non-existent record on delete" do
    get :delete, :record_id => "AAAA", section: "AAAA"
    assert_response :missing
  end
  

end
