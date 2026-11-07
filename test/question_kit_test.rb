require "test_helper"

class QuestionKitTest < ActiveSupport::TestCase
  test "it has a version number" do
    assert QuestionKit::VERSION
  end

  test "it loads easy_flow" do
    assert defined?(EasyFlow::Engine)
  end
end
