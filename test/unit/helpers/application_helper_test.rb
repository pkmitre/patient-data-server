require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "labeled field" do
    assert_equal "<dt>foo</dt> <dd>bar</dd>", labeled_field("foo", "bar")
  end

  test "date_formatter" do
    time = Time.new(2001, 1, 1)
    assert_equal "01-Jan-2001", date(time)
    # Check defaulting behavior with optional parameter
    assert_equal 'present', date(nil, 'present')
    # Check defaulting behavior with default value
    assert_equal 'never', date(nil)
  end

  test "breadcrumbs" do
    @bc = [:title => "abc", :link => "/"]
    assert_equal "<ul class='breadcrumb'><li><a href='/'>abc</a><span class='divider'>/</span></li></ul>", show_breadcrumbs
    @bc = [{:title => "abc", :link => "/"}, {:title => "def"}]
    assert_equal "<ul class='breadcrumb'><li><a href='/'>abc</a><span class='divider'>/</span></li><li>def</li></ul>", show_breadcrumbs
  end

  def breadcrumbs
    @bc
  end
end
