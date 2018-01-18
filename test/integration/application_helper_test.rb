require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'full title helper'
    siteToBuild = I18n.t("brand")
    assert_equal full_title,      siteToBuild
    assert_equal full_title("Help"), "Help | "  +  siteToBuild
  end
end
