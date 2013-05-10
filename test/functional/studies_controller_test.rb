require 'test_helper'
require 'atom_test'

class StudiesControllerTest < AtomTest
  include Devise::TestHelpers
  
  setup do
    @record = FactoryGirl.create(:record, :with_studies)
    @user = FactoryGirl.create(:user)
    sign_in @user
  end
  
  test "get a result" do
    get :index, record_id: @record.medical_record_number
    assert_response :success
    assert_equal @record, assigns[:record]
    assert_equal @record.studies, assigns[:studies]
  end
  
  test "get a result as an Atom feed" do
    request.env['HTTP_ACCEPT'] = 'application/atom+xml'
    get :index, record_id: @record.medical_record_number
    assert_response :success 
    assert_atom_success
    assert_atom_result_count atom_results, @record.studies.size
    assert_equal @record.studies.first.description, atom_results.entries.first.title
  end

  test "check for 404 on non-existent record on index" do
    get :index, record_id: "AAAA"
    assert_response :missing
  end

end
