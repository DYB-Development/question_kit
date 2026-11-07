require "test_helper"

class GuidesTest < ActiveSupport::TestCase
  test "the gem ships an install guide for coding agents" do
    assert_includes gem_files, "the_local/agents/question_kit-install.md"
  end

  private
    def gem_files
      Gem::Specification.load(File.expand_path("../../question_kit.gemspec", __dir__)).files
    end
end
