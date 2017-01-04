require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    siteToBuild = "JuinJuillet"
    assert_equal full_title,      siteToBuild
    assert_equal full_title("Help"), "Help | "  +  siteToBuild
  end
end
