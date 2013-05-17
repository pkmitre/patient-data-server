require 'test_helper'
require 'atom_test'

class ImagesControllerTest < AtomTest
  include Devise::TestHelpers
  
  setup do
    @record = FactoryGirl.create(:record, :with_studies)
    @study = @record.studies.first
    @image = @record.studies.first.images.first
    @user = FactoryGirl.create(:user)
    sign_in @user
  end
  
  test "get index result" do
    get :index, record_id: @record.medical_record_number, study_id: @study.id
    assert_response :success
    assert_equal @record, assigns[:record]
    assert_equal @study, assigns[:study]
    assert_equal @study.images, assigns[:images]
  end
  
  test "get index result as an Atom feed" do
    request.env['HTTP_ACCEPT'] = 'application/atom+xml'
    get :index, record_id: @record.medical_record_number, study_id: @study.id
    assert_response :success 
    assert_atom_success
    assert_atom_result_count atom_results, @study.images.size
    assert_equal "#{@image.series_description} ##{@image.instance_number}", atom_results.entries.first.title
  end

  test "check for 404 on non-existent record on index" do
    get :index, record_id: "AAAA"
    assert_response :missing
  end

  test "get show result as HTML" do
    get :show, record_id: @record.medical_record_number, study_id: @study.id, image_id: @image.id
    assert_response :success
    assert_equal @record, assigns[:record]
    assert_equal @study, assigns[:study]
    assert_equal @image, assigns[:image]
  end

  test "get show result as JPG" do
    get :show, record_id: @record.medical_record_number, study_id: @study.id, image_id: @image.id, format: 'jpg'
    assert_response :success
    assert_equal @record, assigns[:record]
    assert_equal @study, assigns[:study]
    assert_equal @image, assigns[:image]
  end

  test "get show result as DCM" do
    get :show, record_id: @record.medical_record_number, study_id: @study.id, image_id: @image.id, format: 'dcm'
    assert_response :success
    assert_equal @record, assigns[:record]
    assert_equal @study, assigns[:study]
    assert_equal @image, assigns[:image]
  end

  test "check for 404 on non-existent record on show" do
    get :show, record_id: "AAAA"
    assert_response :missing
  end

end
