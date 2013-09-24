require 'test_helper'

class DeflectableTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, Deflectable
  end
end
